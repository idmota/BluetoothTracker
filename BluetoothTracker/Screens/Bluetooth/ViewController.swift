//
//  FiendViewController.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import UIKit
import CoreMotion

class FiendViewController: UIViewController {
    
    var motion = CMMotionManager()
    lazy var tableView = UITableView()
    lazy var delegateDataSource = TableDataSource()
    lazy var bluetoothServices = BluetoothServices()
    
    var models: [BluetoothModel] = []
    var modelsForSave: [BluetoothModel] = []
    var distance: Double = 0
    var step: Double = 0.5
    var isStart: Bool = false
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motion.startGyroUpdates()
        motion.startAccelerometerUpdates()
        
        motion.accelerometerUpdateInterval = 3
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let data = self.motion.accelerometerData {
                print(data.acceleration)
            }
            
            if let guroData = self.motion.gyroData {
                print(guroData.rotationRate)
            }
        }
        bluetoothServices.initCentralManager()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = delegateDataSource
        tableView.dataSource = delegateDataSource
        bluetoothServices.delegate = self
        [
            tableView
        ].forEach { tView in
            tView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tView)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "minus.square")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(minusAction))
        
        let plusButton = UIBarButtonItem(image:
                                            UIImage(systemName: "plus.square")?
                                            .withTintColor(.white, renderingMode: .alwaysOriginal),
                                         style: .plain, target: self,
                                         action: #selector(plusAction))
        let startStopButton = UIBarButtonItem(image:
                                                UIImage(systemName: "playpause.fill")?
                                                .withTintColor(.white, renderingMode: .alwaysOriginal),
                                              style: .plain,
                                              target: self,
                                              action: #selector(startStopAction))
        let saveButton = UIBarButtonItem(image:
                                            UIImage(systemName: "square.and.arrow.up.fill")?
                                            .withTintColor(.white, renderingMode: .alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveActions))
        navigationItem.rightBarButtonItems = [saveButton,plusButton, startStopButton]
        
        updateDistanceLabel()
    }
    
    // MARK: - action
    @objc
    func minusAction() {
        if distance - step >= 0 {
            distance = distance - step
            updateDistanceLabel()
            generator.impactOccurred()
        }
    }
    
    @objc
    func plusAction() {
        if distance + step > 0 {
            distance = distance + step
            updateDistanceLabel()
            generator.impactOccurred()
        }
    }
    
    @objc
    func startStopAction() {
        if isStart {
            bluetoothServices.stop()
        } else {
            bluetoothServices.start()
        }
        isStart = !isStart
        updateDistanceLabel()
        generator.impactOccurred()
    }
    
    @objc
    func saveActions() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        createCSV(from: modelsForSave) {[weak self] in
            let alertVC = UIAlertController(title: "CVS is saved", message: nil, preferredStyle: .alert)
            self?.present(alertVC, animated: true) {
                self?.dismiss(animated: true)
            }
            
        }
    }
    
    func reloadData(models: [BluetoothModel]) {
        delegateDataSource.reloadData(models: models) {
            tableView.reloadData()
        }
    }
    
    func updateDistanceLabel() {
        navigationItem.title = "\(distance) met, \(isStart ? "Scaning..." : "Stopped")"
    }
}

// MARK: - BluetoothServicesOutput
extension FiendViewController: BluetoothServicesOutput {
    
    func getDevices(model: BluetoothModel) {
        var tModel = model
        tModel.setDistance(distance)
        if let index = models.firstIndex(where: { $0 == tModel }) {
            models[index].update(model: tModel)
        } else {
            models.append(tModel)
            models.sort { $0.RSSI > $1.RSSI }
        }
        modelsForSave.append(tModel)
        reloadData(models: models)
    }
}

// MARK: - CVS
extension FiendViewController {
    func createCSV(from models:[BluetoothModel], _ completion: () -> Void) {
        guard let model = models.first else { return }
        var csvString = ""
        
        let arrayKey = Mirror(reflecting: model).children.compactMap({ sValue -> String? in
            guard let title = sValue.label else { return nil }
            return String(describing: title)
        })
        csvString.append(arrayKey.joined(separator: ","))
        csvString.append("\n")
        models.forEach { model in
            let arrayValue = Mirror(reflecting: model).children.compactMap({ sValue -> String? in
                return String(describing: sValue.value)
            })
            csvString.append(arrayValue.joined(separator: ","))
            csvString.append("\n")
        }
        do {
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!  as String
            let sFileName = "sfile.csv"
            let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
            
            try csvString.write(to: documentURL, atomically: true, encoding: .utf8)
        } catch {
            print("error creating file")
        }
        completion()
    }
    
}

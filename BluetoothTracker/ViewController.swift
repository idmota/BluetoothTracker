//
//  ViewController.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView = UITableView()
    lazy var delegateDataSource = TableDataSource()
    lazy var bluetoothServices = BluetoothServices()
    var models: [BluetoothModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bluetoothServices.scan()
    }
    
    func reloadData(models: [BluetoothModel]) {
        delegateDataSource.reloadData(models: models) {
            tableView.reloadData()
        }
    }
}

extension ViewController: BluetoothServicesOutput {
    func getDevices(model: BluetoothModel) {
        if let index = models.firstIndex(where: { $0 == model }) {
            models[index].update(model: model)
        } else {
            models.append(model)
            models.sort { $0.signal > $1.signal }
        }
        
        reloadData(models: models)
    }
}



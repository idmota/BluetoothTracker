//
//  BluetoothServices.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import CoreBluetooth

struct BluetoothModel: Equatable {
    var identifier: UUID
    var title: String
    var distance: Double = 0
    var RSSI: Double
    var power: Double
    var signalmath: Double
    var state: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    mutating func update(model: Self) {
        self.state = model.state
        self.RSSI = model.RSSI
        self.power = model.power
        self.signalmath = model.signalmath
    }
    
    mutating func setDistance(_ distance: Double) {
        self.distance = distance
    }
}

class BluetoothServices: NSObject, BluetoothProtocol {
    var centralManager: CBCentralManager!
    var delegate: BluetoothServicesOutput?
}

protocol BluetoothServicesOutput: AnyObject {
    func getDevices(model: BluetoothModel)
}

extension BluetoothServices: CBCentralManagerDelegate {
    
    func initCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
        @unknown default:
            fatalError()
        }
    }
    
    func start() {
        centralManager.scanForPeripherals(withServices: [])
    }
    
    func stop() {
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        DispatchQueue.global().async { [weak self] in
            if let power = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double, peripheral.name != nil {
                print("Distance is ", pow(10, ((power - Double(truncating: RSSI))/20)))
                
                let model = BluetoothModel(identifier: peripheral.identifier, title: peripheral.name ?? "",
                                           RSSI: Double(truncating: RSSI),
                                           power: power,
                                           signalmath: Double(pow(10, ((power - Double(truncating: RSSI))/20))),
                                           state: peripheral.state.rawValue)
                DispatchQueue.main.async {
                    self?.delegate?.getDevices(model: model)
                }
            }
        }
    }
}


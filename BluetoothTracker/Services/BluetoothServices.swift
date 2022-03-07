//
//  BluetoothServices.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import CoreBluetooth

struct BluetoothModel: Equatable {
    var title: String
    var signal: Int
    var signal2: String
    var signalmath: String
    var identifier: UUID
    var state: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    mutating func update(model: Self) {
        self.state = model.state
        self.signal = model.signal
        self.signal2 = model.signal2
        self.signalmath = model.signalmath
    }
}

class BluetoothServices: NSObject, BluetoothProtocol {
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral!
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
            centralManager.scanForPeripherals(withServices: [])
        @unknown default:
            fatalError()
        }
    }
    
    func scan() {
//        let heartRateServiceCBUUID = CBUUID(string: "0x180D")
//        centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])

        centralManager.scanForPeripherals(withServices: [])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
       
        if let power = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double{
            print("Distance is ", pow(10, ((power - Double(truncating: RSSI))/20)))
            
            let model = BluetoothModel(title: peripheral.name ?? "",
                                       signal: Int(truncating: RSSI),
                                       signal2: String(power),
                                       signalmath: String(pow(10, ((power - Double(truncating: RSSI))/20))),
                                       identifier: peripheral.identifier,
                                       state: peripheral.state.rawValue)
            print(peripheral)
            delegate?.getDevices(model: model)
            
        }
    }
}


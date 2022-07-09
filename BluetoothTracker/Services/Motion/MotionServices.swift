//
//  MotionServices.swift
//  BluetoothTracker
//
//  Created by link on 14.05.2022.
//

import CoreMotion

final class MotionServices {
    let motionManager: CMMotionManager
    var timer: Timer?
    weak var delegate: MotionProtocol?
    
    init() {
        motionManager = CMMotionManager()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] timer in
            guard let self = self else { return }
            if let accelerometerData = self.motionManager.accelerometerData {
                print(accelerometerData)
                self.delegate?.updateAccelerometerData(accelerometerData)
            }
            if let gyroData = self.motionManager.gyroData {
                print(gyroData)
                self.delegate?.updateGyroData(gyroData)
            }
            if let magnetometerData = self.motionManager.magnetometerData {
                print(magnetometerData)
                self.delegate?.updateMagnetometerData(magnetometerData)
            }
            if let deviceMotion = self.motionManager.deviceMotion {
                print(deviceMotion)
                self.delegate?.updateDeviceMotion(deviceMotion)
            }
        })
    }
    
    // open
    func startMotion() {
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
    }
    
    func stopMotion() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
}

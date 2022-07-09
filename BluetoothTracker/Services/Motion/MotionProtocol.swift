//
//  MotionProtocol.swift
//  BluetoothTracker
//
//  Created by link on 14.05.2022.
//

import CoreMotion

protocol MotionProtocol: AnyObject {
    func updateAccelerometerData(_ data: CMAccelerometerData?)
    func updateGyroData(_ data: CMGyroData?)
    func updateMagnetometerData(_ data: CMMagnetometerData?)
    func updateDeviceMotion(_ data: CMDeviceMotion?)
}

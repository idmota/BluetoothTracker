//
//  CompassViewController.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import UIKit
import CoreMotion
class CompassViewController: UIViewController {
        
    let compassView = CompassView()
    let compassHeading = CompassHeading()
    let motionServices = MotionServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compassHeading.delegate = self
        motionServices.delegate = self
        [
            compassView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
       
        NSLayoutConstraint.activate([
            compassView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            compassView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            compassView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
    }
}

// MARK: - CompassHeadingDelegate
extension CompassViewController: CompassHeadingDelegate {
    func changeWithStartAnglee(to value: Double) {
        let angle: CGAffineTransform = CGAffineTransform(rotationAngle: value * CGFloat(CGFloat.pi/180))
        self.compassView.transform = angle
    }
    
    func changeCompassDegrees(to value: Double) {
        let angle: CGAffineTransform = CGAffineTransform(rotationAngle: value * CGFloat(CGFloat.pi/180))
        self.compassView.transform = angle
    }
}

// MARK: - CompassHeadingDelegate
extension CompassViewController: MotionProtocol{
    func updateAccelerometerData(_ data: CMAccelerometerData?) {
        print(#function, data)
    }
    
    func updateGyroData(_ data: CMGyroData?) {
        print(#function, data)
    }
    
    func updateMagnetometerData(_ data: CMMagnetometerData?) {
        print(#function, data)
    }
    
    func updateDeviceMotion(_ data: CMDeviceMotion?) {
        print(#function, data)
    }
    
    
}

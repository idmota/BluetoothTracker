//
//  CompassHeading.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import Foundation
import CoreLocation

final class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
    weak var delegate: CompassHeadingDelegate?
    private var startAnglee: Double?
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        setup()
    }
    
    private func setup() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    private func calculateDegree(_ value: Double) -> Double {
        if startAnglee == nil {
            startAnglee = value
        }
        if let startAnglee = startAnglee {
            if value - startAnglee < 0 {
                return 360 - (startAnglee - value)
            } else {
                return value - startAnglee
            }
        }
        return 0
    }
    
    // MARK: - Open
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [self] in
            delegate?.changeCompassDegrees(to: -newHeading.magneticHeading)
            delegate?.changeWithStartAnglee(to: -calculateDegree(newHeading.magneticHeading))
        }
    }
    
    func clearStartAnglee() {
        startAnglee = nil
    }
}

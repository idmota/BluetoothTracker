//
//  LocationProvider.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import Foundation
import CoreLocation

protocol LocationProviderDelegate: AnyObject {
    func changeDegrees(to value: Double)
}

final class LocationProvider: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    weak var delegate: LocationProviderDelegate?
    private let locationManager: CLLocationManager
    
    public override init() {
//        currentHeading = 0
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingHeading()
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func updateHeading() {
        locationManager.startUpdatingHeading()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.delegate?.changeDegrees(to: Double(newHeading.trueHeading))
            //      self.currentHeading = CGFloat(newHeading.trueHeading)
        }
    }
}

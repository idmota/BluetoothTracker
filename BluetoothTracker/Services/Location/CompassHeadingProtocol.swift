//
//  CompassHeadingProtocol.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import Foundation

protocol CompassHeadingDelegate: AnyObject {
    func changeCompassDegrees(to value: Double)
    func changeWithStartAnglee(to value: Double)
}

//
//  QueueManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import Foundation
import CoreLocation

protocol LocationManager {
    var location: CLLocation? { get }
}

extension LocationManager {
    
    var currentCoordinate: Coordinate? {
        return location?.coordinate.toCoordinate
    }
    
}

extension CLLocationManager: LocationManager {}

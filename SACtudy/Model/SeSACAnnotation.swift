//
//  SeSACAnnotation.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import UIKit
import MapKit

class SeSACAnnotation: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    
    var sesacType = 0
    
    init(lat: Double, long: Double, sesac: Int) {
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        super.init()
        sesacType = sesac
    }
    
}

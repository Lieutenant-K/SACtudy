//
//  HomeMapView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import UIKit
import MapKit

final class HomeMapView: MKMapView {
    
    let annotationReuseIdentifier = "annotation"

    private func configureMapView() {
        
        cameraZoomRange = CameraZoomRange(minCenterCoordinateDistance: 400, maxCenterCoordinateDistance: 24000)
        isPitchEnabled = false
        isRotateEnabled = false
        region = MKCoordinateRegion(center: .defaultCoordinate, latitudinalMeters: 700, longitudinalMeters: 1400)
//        centerCoordinate = .defaultCoordinate
        register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMapView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

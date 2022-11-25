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
        isPitchEnabled = false
        isRotateEnabled = false
        showsScale = false
        centerCoordinate = .defaultCoordinate
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

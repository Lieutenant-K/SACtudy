//
//  MKAnnotation + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {

    /// Typed parent object.
    public weak private(set) var mapView: MKMapView?

    /// - parameter mapView: Parent object for delegate proxy.
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

extension Reactive where Base: MKMapView {
    
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    var currentAnnotations: Binder<[MKAnnotation]> {
        return Binder(base) { base, annotations in
            base.removeAnnotations(base.annotations)
            base.addAnnotations(annotations)
        }
    }
    
    var regionDidChange: ControlEvent<Coordinate> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { [base] _ in base.region.center.toCoordinate }
        return ControlEvent(events: source)
    }
    
}

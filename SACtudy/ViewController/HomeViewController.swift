//
//  MainViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/16.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {
    
    let rootView = HomeView()
    
    let viewModel: HomeViewModel
    
    init(manager: LocationManager) {
        viewModel = HomeViewModel(manager: manager)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.mapView.delegate = self
        binding()
        
    }
    
    func binding() {
        
        let input = HomeViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            floatingButtonTap: rootView.floatingButton.rx.tap,
            gpsButtonTap: rootView.gpsButton.rx.tap,
            regionDidChange: rootView.mapView.rx.regionDidChange
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.errorMessage
            .bind(with: self) { vc, message in
                vc.view.makeToast(message) }
            .disposed(by: disposeBag)
        
        output.myState
            .bind(to: rootView.floatingButton.rx.queueState)
            .disposed(by: disposeBag)
        
        output.mapCenter
            .bind(to: rootView.mapView.rx.centerCoordinate)
            .disposed(by: disposeBag)
        
        output.nearUsers
            .debug()
            .map { $0.map {
                SeSACAnnotation(lat: $0.lat, long: $0.long, sesac: $0.sesac) } }
            .bind(to: rootView.mapView.rx.currentAnnotations)
            .disposed(by: disposeBag)
        
        rootView.floatingButton.rx.tap
            .map { output.myState.value }
            .bind { state in
                switch state {
                case .normal:
                    print("스터디 입력 화면")
                case .waitForMatch:
                    print("새싹 찾기 화면")
                case .matched:
                    print("채팅 화면")
                }
            }
            .disposed(by: disposeBag)
        
        rootView.genderFilter.rx.selectFilter
            .bind(to: rootView.genderFilter.rx.currentFilter)
            .disposed(by: disposeBag)
        
        
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationController?.isNavigationBarHidden = true
    }

}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: rootView.mapView.annotationReuseIdentifier, for: annotation)
//            let view = MKAnnotationView()
        if let annotation = annotation as? SeSACAnnotation {
            view.image = Asset.Images.sesacFace(number: annotation.sesacType)?.image
            
        } else {
            view.image = Asset.Images.mapMarker.image
        }
        
        return view
    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
////        print(#function)
//
//        let coordinate = rootView.mapView.convert(rootView.center, toCoordinateFrom: rootView)
//
//
////        print("중앙 핀이 가르키는 좌표: \(coordinate)")
//
////        print("중앙 핀 위치: \(rootView.center)")
////        print("맵 뷰 중앙 위치: \(mapView.center)")
//
//    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        mapView.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            mapView.isUserInteractionEnabled = true
        }
        
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            rootView.mapView.centerCoordinate = .defaultCoordinate
        case .authorizedAlways, .authorizedWhenInUse:
            if let coordinate = manager.location?.coordinate {
                rootView.mapView.centerCoordinate = coordinate
            }
        case .denied, .restricted:
            rootView.mapView.centerCoordinate = .defaultCoordinate
        default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.map { $0.coordinate } )
        
    }
    
}

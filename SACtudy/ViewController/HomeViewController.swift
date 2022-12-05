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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func binding() {
        
        let input = HomeViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            floatingButtonTap: rootView.floatingButton.rx.tap,
            gpsButtonTap: rootView.gpsButton.rx.tap,
            regionDidChange: rootView.mapView.rx.regionDidChange
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.error
            .bind(with: self) { vc, error in
                switch error {
                case .network:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                case .disabledLocation:
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    let alert = UIAlertController(title: "위치 서비스 사용 불가", message: nil, preferredStyle: .alert)
                    alert.addAction(action)
                    
                    vc.present(alert, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.myState
            .bind(to: rootView.floatingButton.rx.queueState)
            .disposed(by: disposeBag)
        
        output.mapCenter
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            .bind(to: rootView.mapView.rx.centerCoordinate)
            .disposed(by: disposeBag)
        
        output.nearUsers
            .debug()
            .map { $0.map {
                SeSACAnnotation(lat: $0.lat, long: $0.long, sesac: $0.sesac) } }
            .bind(to: rootView.mapView.rx.currentAnnotations)
            .disposed(by: disposeBag)
        
        output.transition
            .bind(with: self) { vc, state in
                let viewController: UIViewController
                let coordinate = vc.rootView.mapView.centerCoordinate.toCoordinate
                
                switch state {
                case .normal:
                    print("스터디 입력 화면")
                    viewController = SearchViewController(coordinate: coordinate)
                case .waitForMatch:
                    print("새싹 찾기 화면")
                    viewController = InspectUserViewController(coordinate: coordinate)
                case let .matched(nick, uid):
                    let chatManager = ChatRepository(uid: uid, socketManager: SocketRepository())
                    let viewModel = ChattingViewModel(manager: chatManager, uid: uid)
                    viewController = ChattingViewController(nickname: nick, viewModel: viewModel)
                    print("채팅 화면")
                }
                
                vc.transition(viewController, isModal: false)
                
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
            view.frame.size = CGSize(width: 80, height: 80)
            view.centerOffset = CGPoint(x: 0, y: -20)
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        mapView.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            mapView.isUserInteractionEnabled = true
        }
    }
    
    /*
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        let coordinate1 = mapView.convert(CGPoint(x: 0, y: mapView.frame.height/2), toCoordinateFrom: mapView)
        
        let coordinate2 = mapView.convert(CGPoint(x: mapView.frame.width/2, y: 0), toCoordinateFrom: mapView)
        
        let center = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        print(center.distance(from: CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)))
        
        print(center.distance(from: CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)))
        
        
    }
    */
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

//
//  HomeViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

enum QueueState {
    case normal, waitForMatch, matched
    
    var iconImage: ImageAsset {
        switch self {
        case .normal:
            return Asset.Images.search
        case .waitForMatch:
            return Asset.Images.antenna
        case .matched:
            return Asset.Images.message
        }
    }
}

enum GenderFilter: Int {
    
    case noFilter = 2
    case man = 1
    case woman = 0
    
}

class HomeViewModel: ViewModel, NetworkManager {
    
    let locationManager: LocationManager
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let floatingButtonTap: ControlEvent<Void>
        let gpsButtonTap: ControlEvent<Void>
        let regionDidChange: ControlEvent<CLLocationCoordinate2D>
    }
    struct Output {
        let myState = BehaviorRelay<QueueState>(value: .normal)
        let mapCenter = BehaviorRelay<CLLocationCoordinate2D>(value: .defaultCoordinate)
        let nearUsers = PublishRelay<[NearUser]>()
        let errorMessage = PublishRelay<String>()
    }
    
    let fetchMyQueueState = PublishRelay<Void>()
    let fetchNearUser = BehaviorRelay<CLLocationCoordinate2D>(value: .defaultCoordinate)
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        fetchMyQueueState
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.request(router: .queue(.myQueueState), type: MyQueueState.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(state):
                    guard let state else { return }
                    let myState: QueueState = state.matched == 0 ? .waitForMatch : .matched
                    output.myState.accept(myState)
                case .status(201):
                    output.myState.accept(.normal)
                case .error(.tokenError):
                    model.fetchMyQueueState.accept(())
                case .error(.network):
                    output.errorMessage.accept(Constant.networkDisconnectMessage)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        fetchNearUser
            .withUnretained(self)
            .flatMapLatest { model, coordinate in
                model.request(router: .queue(.search(lat: coordinate.latitude, long: coordinate.longitude)), type: UserSearchResult.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(searchResult):
                    output.nearUsers.accept(searchResult?.fromQueueDB ?? [])
                case .error(.tokenError):
                    model.fetchNearUser.accept(model.fetchNearUser.value)
                case .error(.network):
                    output.errorMessage.accept(Constant.networkDisconnectMessage)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        
        input.viewWillAppear
            .map{ _ in}
            .bind(to: fetchMyQueueState)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .map { model, _ in
                if let coordinate = model.locationManager.currentCoordinate {
                    return coordinate
                }
                return CLLocationCoordinate2D.defaultCoordinate
            }
            .debug()
            .bind(to: output.mapCenter)
            .disposed(by: disposeBag)
        
        input.floatingButtonTap
            .bind(to: fetchMyQueueState)
            .disposed(by: disposeBag)
        
        input.gpsButtonTap
            .bind(with: self) { model, _ in
                if let coordinate = model.locationManager.location?.coordinate {
                    output.mapCenter.accept(coordinate)
                    return
                }
                output.errorMessage.accept("위치 서비스 사용 불가") }
            .disposed(by: disposeBag)
        
        input.regionDidChange
            .debug()
            .bind(to: fetchNearUser)
            .disposed(by: disposeBag)
        
        return output
    }
    
    init(manager: LocationManager){
        self.locationManager = manager
    }
    
}

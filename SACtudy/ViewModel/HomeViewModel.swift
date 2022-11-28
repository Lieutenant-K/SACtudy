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

enum HomeError: Error {
    case disabledLocation
    case network
}

class HomeViewModel: ViewModel, NetworkManager {
    
    let locationManager: LocationManager
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let floatingButtonTap: ControlEvent<Void>
        let gpsButtonTap: ControlEvent<Void>
        let regionDidChange: ControlEvent<Coordinate>
    }
    struct Output {
        let myState = BehaviorRelay<QueueState>(value: .normal)
        let mapCenter = BehaviorRelay<Coordinate>(value: .defaultCoordinate)
        let nearUsers = PublishRelay<[NearUser]>()
        let error = PublishRelay<HomeError>()
        let transition = PublishRelay<QueueState>()
    }
    
    let fetchMyQueueState = PublishRelay<Void>()
    let fetchNearUser = BehaviorRelay<Coordinate>(value: .defaultCoordinate)
    
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
                    output.error.accept(.network)
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
                    output.error.accept(.network)
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
                return Coordinate.defaultCoordinate
            }
            .debug()
            .bind(to: output.mapCenter)
            .disposed(by: disposeBag)
        
        input.floatingButtonTap
            .bind(with: self) { model, _ in
                if let _ = model.locationManager.currentCoordinate { output.transition.accept(output.myState.value) }
                else { output.error.accept(.disabledLocation) }
            }
            .disposed(by: disposeBag)
        
        
        input.gpsButtonTap
            .bind(with: self) { model, _ in
                if let coordinate = model.locationManager.currentCoordinate {
                    output.mapCenter.accept(coordinate)
                    return
                }
                output.error.accept(.disabledLocation) }
            .disposed(by: disposeBag)
        
        input.regionDidChange
            .map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
            .debug()
            .bind(to: fetchNearUser)
            .disposed(by: disposeBag)
        
        return output
    }
    
    init(manager: LocationManager){
        self.locationManager = manager
    }
    
}

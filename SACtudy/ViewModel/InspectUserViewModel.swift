//
//  InspectUserViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class InspectUserViewModel: ViewModel, NetworkManager {
    
    enum ActionResult {
        case deleteSuccess
        case alreadyMatched
        case changeStudy(Coordinate)
        case network
    }
    
    let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    struct Input {
        let deleteStudyButtonTap: ControlEvent<Void>
        let refreshButtonTap: ControlEvent<Void>
        let changeStudyButtonTap: ControlEvent<Void>
        let nearUserItemSelected: ControlEvent<IndexPath>
        let requestUserItemSelected: ControlEvent<IndexPath>
        let menuTap: ControlEvent<Int>
    }
    
    struct Output {
        let nearUserList = BehaviorRelay<[Section]>(value: [])
        let requestUserList = BehaviorRelay<[Section]>(value: [])
        let actionResult = PublishRelay<ActionResult>()
        let isCurrentEmpty = PublishRelay<Bool>()
    }
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let fetchNearUser = BehaviorRelay<Coordinate>(value: coordinate)
        let deleteStudy = PublishRelay<Void>()
        let changeStudy = PublishRelay<Void>()
        
        fetchNearUser
            .withUnretained(self)
            .flatMapLatest { model, coordinate in
                model.request(router: .queue(.searchNearStudy(coordinate: coordinate)), type: UserSearchResult.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(searchResult):
                    if let data = searchResult {
                        let nearUsers = model.convertToStudy(user: data.fromQueueDB)
                        let requestUsers = model.convertToStudy(user: data.fromQueueDBRequested)
                        output.nearUserList.accept([Section(items: nearUsers)])
                        output.requestUserList.accept([Section(items: requestUsers)])
                    }
                case .error(.tokenError):
                    fetchNearUser.accept(fetchNearUser.value)
                case .error(.network):
                    break
                    //                    output.result.accept(.failure(.network))
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        deleteStudy
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.request(router: .queue(.deleteMyStudy), type: Empty.self)
            }
            .subscribe(with: self) { model, result in
                switch result {
                case .success:
                    output.actionResult.accept(.deleteSuccess)
                case .error(.tokenError):
                    deleteStudy.accept(())
                case .error(.network):
                    output.actionResult.accept(.network)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        changeStudy
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.request(router: .queue(.deleteMyStudy), type: Empty.self)
            }
            .subscribe(with: self) { model, result in
                switch result {
                case .success:
                    output.actionResult.accept(.changeStudy(model.coordinate))
                case .error(.tokenError):
                    changeStudy.accept(())
                case .error(.network):
                    output.actionResult.accept(.network)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteStudyButtonTap
            .bind(to: deleteStudy)
            .disposed(by: disposeBag)
        
        input.refreshButtonTap
            .withUnretained(self)
            .map { model, _ in model.coordinate }
            .bind(to: fetchNearUser)
            .disposed(by: disposeBag)
        
        input.nearUserItemSelected
            .compactMap { index in
                if var items = output.nearUserList.value.first?.items {
                    items[index.row].displayingDetail.toggle()
                    return [Section(items: items)]
                } else { return nil }
            }
            .bind(to: output.nearUserList)
            .disposed(by: disposeBag)
        
        input.requestUserItemSelected
            .compactMap { index in
                if var items = output.requestUserList.value.first?.items {
                    items[index.row].displayingDetail.toggle()
                    return [Section(items: items)]
                } else { return nil }
            }
            .bind(to: output.requestUserList)
            .disposed(by: disposeBag)
        
        input.changeStudyButtonTap
            .bind(to: changeStudy)
            .disposed(by: disposeBag)
            
        
        input.menuTap
            .compactMap {
                $0 == 0 ? output.nearUserList.value.first?.items.isEmpty : output.requestUserList.value.first?.items.isEmpty
            }
            .bind(to: output.isCurrentEmpty)
            .disposed(by: disposeBag)
            
        
        return output
        
    }
    
}

extension InspectUserViewModel {
    
    struct Section: SectionModelType {
        
        var items: [StudyUser]
        
        init(items: [StudyUser]){
            self.items = items
        }
        
        init(original: Section, items: [StudyUser]) {
            self = original
            self.items = items
        }
        
    }
    
    func convertToStudy(user: [NearUser]) -> [StudyUser] {
        
        user.map {
            
            let reputationWithTitles = $0.reputation.enumerated().compactMap { (index, count) in
                if let title = SeSACTitle(rawValue: index) {
                    return ReputationItem(title: title.title, count: count)
                } else { return nil }
            }
            
            return StudyUser(uid: $0.uid,
                      nick: $0.nick,
                      reputation: Reputation(items: reputationWithTitles),
                      studylist: $0.studylist,
                      reviews: $0.reviews,
                      sesac: Asset.Images.sesacFace(number: $0.sesac)?.image,
                      background: Asset.Images.sesacBackground(number: $0.background)?.image,
                    displayingDetail: false
            )
        }
        
    }
    
}

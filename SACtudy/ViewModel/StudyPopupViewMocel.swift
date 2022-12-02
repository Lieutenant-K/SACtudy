//
//  StudyPopupViewMocel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/02.
//

import Foundation
import RxSwift
import RxCocoa

enum PopupType {
    case request, accept
    
    var title: String {
        switch self {
        case .request:
            return "스터디를 요청할게요!"
        case .accept:
            return "스터디를 수락할까요?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .request:
            return "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요"
        case .accept:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        }
    }
}

class StudyPopupViewModel: ViewModel, NetworkManager {
    
    enum ActionResult {
        case requestSuccess
        case acceptSuccess
        case network
        case deniedRequest
        case alreadyRequestToMe
        case anotherAlreadyMatched
        case alreadyMatched
        
        var message: String {
            switch self {
            case .requestSuccess:
                return "스터디 요청을 보냈습니다"
            case .acceptSuccess:
                return "성공적으로 매칭되었습니다"
            case .alreadyRequestToMe:
                return "상대방도 스터디를 요청하여 매칭되었습니다.\n잠시 후 채팅방으로 이동합니다"
            case .anotherAlreadyMatched:
                return "상대방이 이미 다른 새싹과 스터디를 함께하는 중입니다"
            case .deniedRequest:
                return "상대방이 스터디 찾기를 그만두었습니다"
            case .alreadyMatched:
                return "앗! 누군가가 나의 스터디를 수락하였어요!"
            case .network:
                return Constant.networkDisconnectMessage
            }
        }
    }
    
    let uid: String
    let type: PopupType
    
    init(uid: String, type: PopupType) {
        self.uid = uid
        self.type = type
    }
    
    struct Input {
        let okButtonTap: ControlEvent<Void>
        let cancelButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let actionResult = PublishRelay<ActionResult>()

    }
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        if type == .request {
            
            let requestStudy = PublishRelay<String>()
            requestStudy
                .withUnretained(self)
                .flatMapLatest { model, uid in
                    model.request(router: .queue(.requestStudyTo(uid: uid)), type: Empty.self) }
                .subscribe(with: self) { model, result in
                    switch result {
                    case .success:
                        output.actionResult.accept(.requestSuccess)
                    case .error(.network):
                        output.actionResult.accept(.network)
                    case .error(.tokenError):
                        requestStudy.accept(model.uid)
                    case .status(201):
                        output.actionResult.accept(.alreadyRequestToMe)
                    case .status(202):
                        output.actionResult.accept(.deniedRequest)
                    default:
                        print(result)
                    }
                }
                .disposed(by: disposeBag)
            
            input.okButtonTap
                .withUnretained(self)
                .map{ model, _ in model.uid }
                .bind(to: requestStudy)
                .disposed(by: disposeBag)
            
        } else {
            
            let acceptStudy = PublishRelay<String>()
            acceptStudy
                .withUnretained(self)
                .flatMapLatest { model, uid in
                    model.request(router: .queue(.acceptStudyWith(uid: uid)), type: Empty.self) }
                .subscribe(with: self) { model, result in
                    switch result {
                    case .success:
                        output.actionResult.accept(.acceptSuccess)
                    case .error(.network):
                        output.actionResult.accept(.network)
                    case .error(.tokenError):
                        acceptStudy.accept(model.uid)
                    case .status(201):
                        output.actionResult.accept(.anotherAlreadyMatched)
                    case .status(202):
                        output.actionResult.accept(.deniedRequest)
                    case .status(203):
                        output.actionResult.accept(.alreadyMatched)
                    default:
                        print(result)
                    }
                }
                .disposed(by: disposeBag)
            
            input.okButtonTap
                .withUnretained(self)
                .map{ model, _ in model.uid }
                .bind(to: acceptStudy)
                .disposed(by: disposeBag)
            
            
        }
        
//        let fetchNearUser = BehaviorRelay<Coordinate>(value: coordinate)
//        let deleteStudy = PublishRelay<Void>()
//        let changeStudy = PublishRelay<Void>()d
//
//        fetchNearUser
//            .withUnretained(self)
//            .flatMapLatest { model, coordinate in
//                model.request(router: .queue(.searchNearStudy(coordinate: coordinate)), type: UserSearchResult.self) }
//            .subscribe(with: self) { model, result in
//                switch result {
//                case let .success(searchResult):
//                    if let data = searchResult {
//                        let nearUsers = model.convertToStudy(user: data.fromQueueDB)
//                        let requestUsers = model.convertToStudy(user: data.fromQueueDBRequested)
//                        output.nearUserList.accept([Section(items: nearUsers)])
//                        output.requestUserList.accept([Section(items: requestUsers)])
//                    }
//                case .error(.tokenError):
//                    fetchNearUser.accept(fetchNearUser.value)
//                case .error(.network):
//                    break
//                    //                    output.result.accept(.failure(.network))
//                default:
//                    print(result)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        deleteStudy
//            .withUnretained(self)
//            .flatMapLatest { model, _ in
//                model.request(router: .queue(.deleteMyStudy), type: Empty.self)
//            }
//            .subscribe(with: self) { model, result in
//                switch result {
//                case .success:
//                    output.actionResult.accept(.deleteSuccess)
//                case .error(.tokenError):
//                    deleteStudy.accept(())
//                case .error(.network):
//                    output.actionResult.accept(.network)
//                default:
//                    print(result)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        changeStudy
//            .withUnretained(self)
//            .flatMapLatest { model, _ in
//                model.request(router: .queue(.deleteMyStudy), type: Empty.self)
//            }
//            .subscribe(with: self) { model, result in
//                switch result {
//                case .success:
//                    output.actionResult.accept(.changeStudy(model.coordinate))
//                case .error(.tokenError):
//                    changeStudy.accept(())
//                case .error(.network):
//                    output.actionResult.accept(.network)
//                default:
//                    print(result)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        input.deleteStudyButtonTap
//            .bind(to: deleteStudy)
//            .disposed(by: disposeBag)
//
//        input.refreshButtonTap
//            .withUnretained(self)
//            .map { model, _ in model.coordinate }
//            .bind(to: fetchNearUser)
//            .disposed(by: disposeBag)
//
//        input.nearUserItemSelected
//            .compactMap { index in
//                if var items = output.nearUserList.value.first?.items {
//                    items[index.row].displayingDetail.toggle()
//                    return [Section(items: items)]
//                } else { return nil }
//            }
//            .bind(to: output.nearUserList)
//            .disposed(by: disposeBag)
//
//        input.requestUserItemSelected
//            .compactMap { index in
//                if var items = output.requestUserList.value.first?.items {
//                    items[index.row].displayingDetail.toggle()
//                    return [Section(items: items)]
//                } else { return nil }
//            }
//            .bind(to: output.requestUserList)
//            .disposed(by: disposeBag)
//
//        input.changeStudyButtonTap
//            .bind(to: changeStudy)
//            .disposed(by: disposeBag)
//
//
//        input.menuTap
//            .compactMap {
//                $0 == 0 ? output.nearUserList.value.first?.items.isEmpty : output.requestUserList.value.first?.items.isEmpty
//            }
//            .bind(to: output.isCurrentEmpty)
//            .disposed(by: disposeBag)
            
        
        return output
        
    }
    
    
}

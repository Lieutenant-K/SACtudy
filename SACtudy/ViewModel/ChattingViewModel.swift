//
//  ChattingViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ChattingViewModel: ViewModel, NetworkManager {
    let manager: ChatManager
    let uid: String
    
    init(manager: ChatManager, uid: String) {
        self.manager = manager
        self.uid = uid
    }
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let chattingText: ControlProperty<String?>
        let sendButtonTap: Observable<String>
        let menuButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let chatList = PublishRelay<[Section]>()
        let isStduyEnded = PublishRelay<MatchState>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let fetchMyState = PublishRelay<Void>()
        
        fetchMyState
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.request(router: .queue(.myQueueState), type: MyQueueState.self)
            }
            .subscribe(with: self) { model, result in
                var matchState = MatchState(uid: model.uid, isEnd: true)
                switch result {
                case let .success(state):
                    guard let state else { return }
                    let isEnd = state.matched == 1 && state.dodged == 0 && state.reviewed == 0 ? false : true
                    matchState.isEnd = isEnd
                    output.isStduyEnded.accept(matchState)
                case .status(201):
                    output.isStduyEnded.accept(matchState)
                case .error(.tokenError):
                    fetchMyState.accept(())
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { model, _ in
                fetchMyState.accept(())
                model.manager.fetchChatData()
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTap
            .compactMap{ $0 }
            .subscribe(with: self){ model, text in
                model.manager.sendChat(content: text)
            }
            .disposed(by: disposeBag)
        
        input.menuButtonTap
            .bind(to: fetchMyState)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(manager.fetchChatList(), UserRepository.shared.fetchUserData())
            .debug()
            .map { (chatList, user) in
                guard let user else { return [] }
                let items = chatList.map {
                    Item(id: $0.id, isMine: $0.from == user.uid, content: $0.content, createdAt: $0.createdAt.toChatDateString)
                }
                return [Section(items: items)]
            }
            .bind(to: output.chatList)
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension ChattingViewModel {
    struct MatchState {
        let uid: String
        var isEnd: Bool
    }
}

extension ChattingViewModel {
    struct Section: AnimatableSectionModelType {
        var items: [Item]
        var identity: [Item] {
            return items
        }
        
        init(items: [Item]){
            self.items = items
        }
        
        init(original: ChattingViewModel.Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    struct Item: IdentifiableType, Hashable, ChatData {
        let id: String
        let isMine: Bool
        let content: String
        let createdAt: String
        var identity: String {
            return id
        }
    }
}

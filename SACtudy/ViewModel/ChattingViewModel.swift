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

class ChattingViewModel: ViewModel {
    
    let manager: ChatManager
    let uid: String
    
    init(manager: ChatManager, uid: String) {
        self.manager = manager
        self.uid = uid
    }
    
    struct Input {
        let viewWillAppear: ControlEvent<Void>
        let chattingText: ControlProperty<String?>
        let sendButtonTap: Observable<String>
    }
    
    struct Output {
        let buttonValidation = PublishRelay<Bool>()
        let chatList = PublishRelay<[Section]>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .subscribe(with: self) { model, _ in
                model.manager.fetchChatData()}
            .disposed(by: disposeBag)
        
        input.sendButtonTap
            .compactMap{ $0 }
            .subscribe(with: self){ model, text in
                model.manager.sendChat(content: text)
            }
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

//
//  ChatRepository.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/03.
//

import UIKit
import RxSwift
import RxCocoa

class ChatRepository: NetworkManager {
    
    private let webSocketManager: WebSocketManager
    private let disposeBag = DisposeBag()
    private let chatList = BehaviorSubject<[Chat]>(value: [])
    private let fetchChat = PublishRelay<Date>()
    private let saveChat = PublishRelay<[Chat]>()
    private let sendChat = BehaviorRelay<String?>(value: nil)
    private let uid: String
    
    init(uid: String, socketManager: WebSocketManager) {
        self.uid = uid
        self.webSocketManager = socketManager
        binding()
        print("realmFilePath: ",realmPath)
    }
}

extension ChatRepository: DatabaseManager {
    
    typealias Data = ChatRoom
    
    private func binding() {
        saveChatBinding()
        sendChatBinding()
        fetchChatBinding()
    }
    
    private func saveChatBinding() {
        saveChat
            .withUnretained(self)
            .map { repo, newData in
                
                if let room = repo.fetchData(key: repo.uid) {
                    repo.updateData {
                        room.chat.append(objectsIn: newData)
                    }
                }
                let chatList = repo.fetchData(key: repo.uid)?.chatList ?? []
                return chatList
            }
            .subscribe(chatList)
            .disposed(by: disposeBag)
    }
    
    private func sendChatBinding() {
        sendChat
            .compactMap{ $0 }
            .withUnretained(self)
            .flatMapLatest { repo, content in
                repo.request(router: .chat(.sendChat(uid: repo.uid, content: content)), type: Chat.self)
            }
            .subscribe(with: self) { repo, result in
                let chatContent = repo.sendChat.value
                switch result {
                    
                case let .success(chat):
                    if let chat {
                        repo.saveChat.accept([chat])
                    }
                    
                case .status(201):
                    UIApplication.topViewController()?.view.makeToast("스터디가 종료되어 채팅을 전송할 수 없습니다")
                    
                case .error(.network):
                    UIApplication.topViewController()?.view.makeToast(Constant.networkDisconnectMessage)
                    
                case .error(.tokenError):
                    repo.sendChat.accept(chatContent)
                    
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchChatBinding() {
       fetchChat
        .withUnretained(self)
        .flatMapLatest { repo, date in
            repo.request(router: .chat(.getChatList(uid: repo.uid, latestDate: date.toBirthString)), type: UserChatList.self)
        }
        .subscribe(with: self) { repo, result in
            switch result {
                
            case let .success(chatList):
                if let list = chatList?.payload {
                    repo.saveChat.accept(list)
                    repo.startToReceiveChat()
                }
                
            case .error(.network):
                UIApplication.topViewController()?.view.makeToast(Constant.networkDisconnectMessage)
                
            case .error(.tokenError):
                repo.fetchChat.accept(repo.fetchLatestDate())
                
            default:
                print(result)
            }
        }
        .disposed(by: disposeBag)
    }
}

extension ChatRepository: ChatManager {
    
    private func fetchLatestDate() -> Date {
        let chatRoom = fetchData(key: uid) ?? saveData(data: ChatRoom(id: uid, chat: []))
        
        let defaultDate = DateComponents(calendar: Calendar(identifier: .iso8601), year: 2000, month: 1, day: 1).date!
        
        let latestDate = chatRoom.chat.sorted(byKeyPath: "createdAt", ascending: false).first?.createdAt ?? defaultDate
        return latestDate
    }
    
    func fetchChatList() -> Observable<[Chat]> {
        return chatList
    }
    
    func fetchChatData() {
        fetchChat.accept(fetchLatestDate())
    }
    
    func sendChat(content: String) {
        sendChat.accept(content)
    }
    
}

extension ChatRepository {
    
    private func startToReceiveChat() {
        
        webSocketManager.listenEvent(event: "chat") { [weak self] data in
            if let json = data.first, let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                
                guard let chat = try? JSONDecoder().decode(Chat.self, from: jsonData) else { return }
                
                self?.saveChat.accept([chat])
            }
        }
        
        webSocketManager.connect()
    }
    
}

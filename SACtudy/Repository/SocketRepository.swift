//
//  SocketRepository.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import Foundation
import RxSwift
import SocketIO

class SocketRepository: WebSocketManager {
    
    private let socketManager = SocketManager(socketURL: Constant.socketURL, config: [.forceWebsockets(true), .log(true)])
    private let disposeBag = DisposeBag()
    
    deinit {
        disconnect()
    }
    
    func connect(){
        let socket = socketManager.defaultSocket
        UserRepository.shared.fetchUserData()
            .compactMap { $0?.uid }
            .subscribe(with: self) { repo, myUid in
                socket.on(clientEvent: .connect) { data, ack in
                    socket.emit("changesocketid", myUid)
                }
                socket.connect()
            }
            .disposed(by: disposeBag)
    }
    
    func disconnect() {
        socketManager.defaultSocket.disconnect()
    }
    
    func listenEvent(event: String, completaion: @escaping ([Any]) -> Void) {
        socketManager.defaultSocket.on(event) { data, ack in
            completaion(data)
        }
    }
    
}

//
//  ChatManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/02.
//

import Foundation
import RxSwift

protocol ChatManager {
    
    func fetchChatList() -> Observable<[Chat]>
    func sendChat(content: String)
    func fetchChatData()
    
}

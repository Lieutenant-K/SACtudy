//
//  ChatRoom.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/27.
//

import Foundation
import RealmSwift

class ChatRoom: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var chat: List<Chat>
    
    var chatList: [Chat] {
        get { chat.map{$0} }
        set {
            chat.removeAll()
            chat.append(objectsIn: newValue)
        }
    }
    
    convenience init(id: String, chat: [Chat]) {
        self.init()
        self.id = id
        self.chatList = chat
    }
}

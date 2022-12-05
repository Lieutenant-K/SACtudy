//
//  WebSocketManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import Foundation

protocol WebSocketManager {
    func connect()
    func disconnect()
    func listenEvent(event: String, completaion: @escaping ([Any]) -> Void)
}

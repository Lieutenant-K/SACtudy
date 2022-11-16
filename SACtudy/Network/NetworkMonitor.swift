//
//  NetworkMonitor.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/17.
//

import Foundation
import Network

final class NetworkMonitor{
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unknown
    
    /// 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        print("startMonitoring 호출")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("path :\(path)")

            self?.isConnected = path.status == .satisfied
            self?.getConenctionType(path)

            if self?.isConnected == true{
                print("네트워크 연결됨")
            }else{
                print("네트워크 끊어짐")

            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    
    private func getConenctionType(_ path:NWPath) {
        
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
            print("wifi에 연결")

        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")

        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")

        }else {
            connectionType = .unknown
            print("unknown ..")
        }
    }
}

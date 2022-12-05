//
//  Constant.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/15.
//

import Foundation


struct Constant {
    
    static var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210/\(APIVersion)")!
    }
    
    static var APIVersion: String {
        return "v1"
    }
    
    static var socketURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210/")!
    }
    
    static var idtoken: String {
        get { UserDefaults.standard.string(forKey: "idtoken") ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: "idtoken") }
    }
    
    static var FCMtoken: String {
        get { UserDefaults.standard.string(forKey: "FCMtoken") ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: "FCMtoken") }
    }
    
    static var networkDisconnectMessage: String {
        "네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!"
    }
    
    
}

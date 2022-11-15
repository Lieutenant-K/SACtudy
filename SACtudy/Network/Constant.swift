//
//  Constant.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/15.
//

import Foundation


struct Constant {
    
    static var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207/\(APIVersion)")!
    }
    
    static var APIVersion: String {
        return "v1"
    }
    
    static var idtoken: String {
        get { UserDefaults.standard.string(forKey: "idtoken") ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: "idtoken") }
    }
    
    static var FCMtoken: String {
        get { UserDefaults.standard.string(forKey: "FCMtoken") ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: "FCMtoken") }
    }
    
    
}

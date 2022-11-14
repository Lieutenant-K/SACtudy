//
//  NetworkManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func requestSignup(parameter: Parameters) -> DataRequest {
        
        let url = EndPoint.user(.signUp).url
        
        let token = UserDefaults.standard.string(forKey: "idtoken") ?? ""
        
        let header: HTTPHeaders = ["idtoken":token]
        
        return AF.request(url, method: .post, parameters: parameter, headers: header)
        
    }
    
    func requestLogin(token: String) -> DataRequest {
        
        let url = EndPoint.user(.login).url
 
        let header: HTTPHeaders = ["idtoken":token]
        
        return AF.request(url, method: .get, headers: header)
            
        
    }
    
}

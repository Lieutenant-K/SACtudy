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
    
    func requestLogin(token: String, completion: @escaping (Result<User, LoginError>) -> Void) {
        
        let baseURL = "http://api.sesac.co.kr:1207"
        let version = "/v1"
        let url = baseURL + version + "/user"
 
        let header: HTTPHeaders = ["idtoken":token]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: User.self ) { response in
            
            
            switch response.result {
            case let .success(user):
                completion(Result.success(user))
            case .failure(let error):
                
                print(error.localizedDescription)
                guard let response = response.response else {
                    print("서버 응답이 없습니다.")
                    return
                }
                
                let logInError = LoginError(rawValue: response.statusCode)!
                
                completion(Result.failure(logInError))
            }
            
            
        }
        
    }
    
}

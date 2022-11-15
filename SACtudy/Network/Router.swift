//
//  Router.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/15.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    // MARK: - Cases
    case signUp(data: SignUpData)
    case login
    
    // MARK: - Methods
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signUp:
            return .post
        }
    }
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .signUp, .login:
            return "/user"
        }
    }
    
    // MARK: - Header
    var header: HTTPHeaders {
        switch self {
        default:
            return ["idtoken":Constant.idtoken]
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login:
            return nil
        case let .signUp(data):
            return [
                "phoneNumber": data.phoneNumber,
                "FCMtoken":data.FCMToken,
                "nick": data.nickname,
                "birth": data.birth,
                "email": data.email,
                "gender": data.gender
            ]
        }
    }
    
    /*
    var dataType: Codable? {
        switch self {
        case .signUp(let data):
            return nil
        case .login:
            return User
        }
    }
    */
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        let url = Constant.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
    
        
        urlRequest.method = method
        urlRequest.headers = header
        
        
        // Common Headers
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue(APIConstants.token, forHTTPHeaderField: HTTPHeaderField.xAuthToken.rawValue)
        
        if let parameters = parameters {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}

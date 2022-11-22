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
    case signUp(data: PersonalInfomation)
    case login
    case updateUserSetting(data: User.UserSetting)
    case withdraw
    
    // MARK: - Methods
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signUp, .withdraw:
            return .post
        case .updateUserSetting:
            return .put
        }
    }
    
    // MARK: - Paths
    var path: String {
        switch self {
        case .signUp, .login:
            return "/user"
        case .updateUserSetting:
            return "/user/mypage"
        case .withdraw:
            return "/user/withdraw"
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
        case .login, .withdraw:
            return nil
        case let .signUp(data):
            return [
                "phoneNumber": data.phoneNumber ?? "",
                "FCMtoken":data.FCMtoken ?? "",
                "nick": data.nickname ?? "",
                "birth": data.birth ?? "",
                "email": data.email ?? "",
                "gender": data.gender ?? -1
            ]
        case let .updateUserSetting(data):
            return [
                "searchable": data.searchable,
                "ageMin":data.ageMin,
                "ageMax": data.ageMax,
                "gender": data.gender,
                "study": data.study
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

//
//  Router.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/15.
//

import Foundation
import Alamofire

enum UserURI: URI {
    
    case signUp(data: PersonalInfomation)
    case login
    case updateUserSetting(data: User.UserSetting)
    case withdraw
    
    var baseURI: String {
        return "/user"
    }
    
    var subURI: String {
        switch self {
        case .signUp, .login:
            return ""
        case .updateUserSetting:
            return "/mypage"
        case .withdraw:
            return "/withdraw"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .withdraw:
            return .post
        case .login:
            return .get
        case .updateUserSetting:
            return .put
        }
    }
    
    
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
    
}

enum QueueURI: URI {
    
    case myQueueState
    case searchNearStudy(coordinate: Coordinate)
    case requestMyStudy(data: StudyRequestModel)
    
    var baseURI: String {
        return "/queue"
    }
    
    var subURI: String {
        switch self {
        case .myQueueState:
            return "/myQueueState"
        case .searchNearStudy:
            return "/search"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myQueueState:
            return .get
        case .searchNearStudy, .requestMyStudy:
            return .post
        }
    }
    
    
    var parameters: Parameters? {
        switch self {
        case let .searchNearStudy(coordinate):
            return ["lat": coordinate.latitude, "long": coordinate.longitude]
        case let .requestMyStudy(data):
            return ["lat":data.coordinate.latitude, "long": data.coordinate.longitude, "studylist": data.studyList]
        default:
            return nil
        }
    }
    
}

enum Router: URLRequestConvertible {
    
    // MARK: - Cases
    case user(UserURI)
    case queue(QueueURI)
    
    var uri: URI {
        switch self {
        case let .user(uri):
            return uri
        case let .queue(uri):
            return uri
        }
    }
    
    // MARK: - Methods
    var method: HTTPMethod {
        return uri.method
    }
    
    // MARK: - Paths
    var path: String {
        return uri.path
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
        return uri.parameters
    }
    
    
    // MARK: - URL Request
    func asURLRequest() throws -> URLRequest {
        let url = Constant.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
    
        
        urlRequest.method = method
        urlRequest.headers = header
        
        
        // Common Headers
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {

            return try URLEncoding(arrayEncoding: .noBrackets).encode(urlRequest, with: parameters)
            
//            return try URLEncoding.default.encode(urlRequest, with: parameters)
            

        }

        return urlRequest
    }
}

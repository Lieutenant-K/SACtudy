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
    case updateFCMToken(token: String)
    case shopInfo
    case updateShopItem(data: ProductApplyModel)
    case purchaseItem(data: PurchaseItemModel)
    
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
        case .updateFCMToken:
            return "/update_fcm_token"
        case .shopInfo:
            return "/shop/myinfo"
        case .updateShopItem:
            return "/shop/item"
        case .purchaseItem:
            return "/shop/ios"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .withdraw, .updateShopItem, .purchaseItem:
            return .post
        case .login, .shopInfo:
            return .get
        case .updateUserSetting, .updateFCMToken:
            return .put
        }
    }
    
    
    var parameters: Parameters? {
        switch self {
        case .login, .withdraw, .shopInfo:
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
        case let .updateFCMToken(token):
            return ["FCMtoken": token]
        case let .updateShopItem(data):
            return ["sesac": data.sesac, "background": data.background]
        case let .purchaseItem(data):
            return ["receipt": data.receiptString ?? "", "product": data.productId]
        }
    }
    
}

enum QueueURI: URI {
    
    case myQueueState
    case searchNearStudy(coordinate: Coordinate)
    case requestMyStudy(data: StudyRequestModel)
    case deleteMyStudy
    case requestStudyTo(uid: String)
    case acceptStudyWith(uid: String)
    case cancelStudy(uid: String)
    case writeReview(data: WriteReviewModel)
    
    var baseURI: String {
        return "/queue"
    }
    
    var subURI: String {
        switch self {
        case .myQueueState:
            return "/myQueueState"
        case .searchNearStudy:
            return "/search"
        case .requestStudyTo:
            return "/studyrequest"
        case .acceptStudyWith:
            return "/studyaccept"
        case .cancelStudy:
            return "/dodge"
        case let .writeReview(data):
            return "/rate/\(data.uid)"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myQueueState:
            return .get
        case .searchNearStudy, .requestMyStudy, .requestStudyTo, .acceptStudyWith, .cancelStudy, .writeReview:
            return .post
        case .deleteMyStudy:
            return .delete
        }
    }
    
    
    var parameters: Parameters? {
        switch self {
        case let .searchNearStudy(coordinate):
            return ["lat": coordinate.latitude, "long": coordinate.longitude]
        case let .requestMyStudy(data):
            return ["lat":data.coordinate.latitude, "long": data.coordinate.longitude, "studylist": data.studyList]
        case let .requestStudyTo(uid):
            return ["otheruid": uid]
        case let .acceptStudyWith(uid):
            return ["otheruid": uid]
        case let .cancelStudy(uid):
            return ["otheruid": uid]
        case let .writeReview(data):
            return ["otheruid": data.uid,
                    "reputation": data.reputation,
                    "comment":data.comment]
        default:
            return nil
        }
    }
    
}

enum ChatURI: URI {
    
    case sendChat(uid: String, content: String)
    case getChatList(uid: String, latestDate: String)
    
    var baseURI: String {
        return "/chat"
    }
    
    var subURI: String {
        switch self {
        case let .sendChat(uid,_):
            return "/\(uid)"
        case let .getChatList(uid, _):
            return "/\(uid)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendChat:
            return .post
        case .getChatList:
            return .get
        }
    }
    
    
    var parameters: Parameters? {
        switch self {
        case .sendChat(_, let content):
            return ["chat":content]
        case .getChatList(_, let latestDate):
            return ["lastchatDate":latestDate]
        }
    }
    
}

enum Router: URLRequestConvertible {
    
    // MARK: - Cases
    case user(UserURI)
    case queue(QueueURI)
    case chat(ChatURI)
    
    var uri: URI {
        switch self {
        case let .user(uri):
            return uri
        case let .queue(uri):
            return uri
        case let .chat(uri):
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

            return try URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets).encode(urlRequest, with: parameters)

        }

        return urlRequest
    }
}

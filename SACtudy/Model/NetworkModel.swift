//
//  NetworkModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import Alamofire

enum UserURI {
    
    case withdraw, updateFCMToken, login, signUp
    
    var uri: String {
        switch self {
        case .withdraw:
            return "/withdraw"
        case .updateFCMToken:
            return "update_fcm_token"
        default:
            return ""
        }
    }
    
}

enum EndPoint {
    
    case user(UserURI)
    
    var baseURL: String {
        "http://api.sesac.co.kr:1207"
    }
    
    var version: String { "/v1" }
    
    var url: String {
        switch self {
        case .user(let userURI):
            return baseURL + version + "/user" + userURI.uri
        }
    }
    
}

enum LoginError: Int, Error {
    
    case tokenError = 401
    case unregisterdUser = 406
    case serverError = 500
    case clientError = 501
    case networkingError = 0
    
    var message: String {
        switch self {
        case .tokenError:
            return "파이어베이스 토큰이 잘못됐습니다."
        case .unregisterdUser:
            return "서버에 등록되지 않은 회원입니다."
        case .serverError:
            return "서버에서 오류가 발생했습니다."
        case .clientError:
            return "클라이언트 에러가 발생했습니다. 요청의 헤더나 바디를 확인해주세요"
        case .networkingError:
            return "네트워크 응답이 없거나 에러가 발생했습니다."
        }
    }
    
}

struct SignUpParameter {
    
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
    
    var paramenter: Parameters {
        
        [
            "phoneNumber":phoneNumber,
            "FCMtoken":FCMtoken,
            "nick":nick,
            "birth":birth,
            "email":email,
            "gender":gender
         ]
    }
    
    
}

struct User: Codable {
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

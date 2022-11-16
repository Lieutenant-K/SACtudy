//
//  NetworkModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import Alamofire

struct SignUpData {
    
    static var phoneNumber: String {
        get { UserDefaults.standard.string(forKey: "phoneNumber") ?? ""}
        set { UserDefaults.standard.setValue(newValue, forKey: "phoneNumber") }
    }
    static var nickname = ""
    static var birth = ""
    static var email = ""
    static var gender = -1
    static var nicknameViewController = NicknameViewController()
    
    let phoneNumber: String
    let nickname: String
    let birth: String
    let email: String
    let gender: Int
    let FCMToken: String
    
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

enum SeSACError: Int, Error {
    
    case tokenError = 401
    case notRegistered = 406
    case serverError = 500
    case clientError = 501
    case networkDisconnected = -1
    case noResponse = -2
    case otherError = 0
    
    var message: String {
        switch self {
        case .tokenError:
            return "아이디 토큰 만료 401"
        case .notRegistered:
            return "가입되지 않은 회원입니다. 406"
        case .serverError:
            return "서버 에러 500"
        case .clientError:
            return "클라이언트 에러 501"
        case .otherError:
            return "기타 다른 에러"
        case .noResponse:
            return "서버 응답 없음"
        case .networkDisconnected:
            return "네트워크 연결이 원활하지 않습니다.\n연결상태 확인 후 다시 시도해 주세요!"
        }
    }
    
}

enum SeSACResponse {
    
    case success(Int)
    case failure(SeSACError)
    
}

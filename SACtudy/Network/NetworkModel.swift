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
    static weak var nicknameViewController: NicknameViewController?
    
    let phoneNumber: String
    let nickname: String
    let birth: String
    let email: String
    let gender: Int
    let FCMToken: String
    
}

struct Empty: Codable {}

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

extension User {
    
    struct UserSetting {
        
        var study: String
        var searchable: Int
        var ageMin: Int
        var ageMax: Int
        var gender: Int
        
    }
    
    var userSetting: UserSetting {
        UserSetting(study: self.study, searchable: self.searchable, ageMin: self.ageMin, ageMax: self.ageMax, gender: self.gender)
    }
    
}

enum APIError: Error, Equatable {
    
    case tokenError
    case serverError
    case clientError
    case networkDisconnected
    case noResponse
    case uniqueError(Int)
    
    var statusCode: Int {
        switch self {
        case .tokenError:
            return 401
        case .serverError:
            return 500
        case .clientError:
            return 501
        case .networkDisconnected:
            return -1
        case .noResponse:
            return 0
        case .uniqueError(let code):
            return code
        }
            
    }
        
    
    var message: String {
        switch self {
        case .tokenError:
            return "아이디 토큰 만료 401"
        case .serverError:
            return "서버 에러 500"
        case .clientError:
            return "클라이언트 에러 501"
        case .noResponse:
            return "서버 응답 없음"
        case .networkDisconnected:
            return Constant.networkDisconnectMessage
        case .uniqueError(let code):
            return "특별한 에러 코드: \(code)"
        }
    }
    
}

enum SeSACResponse {
    
    case success(Int)
    case failure(APIError)
    
}

enum SeSACTitle: Int {
    
    case goodManner = 0
    case correctAppointmnet
    case rapidResponse
    case kindness
    case skillful
    case educational
    
    var title: String {
        switch self {
        case .goodManner:
            return "좋은 매너"
        case .correctAppointmnet:
            return "정확한 시간 약속"
        case .rapidResponse:
            return "빠른 응답"
        case .kindness:
            return "친절한 성격"
        case .skillful:
            return "능숙한 실력"
        case .educational:
            return "유익한 시간"
        }
    }
    
}

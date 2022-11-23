//
//  NetworkModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import Alamofire

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

enum APIErrors: Int, Error {
    
    case tokenError = 401
    case serverError = 500
    case clientError = 501
    case network = -1
    case noResponse = 0
    
}

enum APIResult<T: Decodable> {
    
    case success(T?)
    case error(APIErrors)
    case status(Int)
    
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

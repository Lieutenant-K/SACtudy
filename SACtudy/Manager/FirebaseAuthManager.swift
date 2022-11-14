//
//  FirebaseAuthManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    
    var errorMessage: String {
        switch code {
        case .invalidPhoneNumber:
            return "잘못된 전화번호 형식입니다."
        case .tooManyRequests:
            return "과도한 인증 시도가 있었습니다.\n나중에 다시 시도해 주세요."
        case .invalidVerificationCode, .sessionExpired:
            return "전화 번호 인증 실패"
        default:
            return "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
        }
    }
    
}

class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    private init() {}
    
    func requestAuthCode(phoneNumber: String, completion: @escaping (Result<String, AuthErrorCode>) -> Void) {
        
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            if let error = error as? AuthErrorCode {
                
                completion(Result.failure(error))
                return
            }
            if let verificationID {
                completion(Result.success(verificationID))
            }
            
        }
        
    }
    
    func authorizeWithCode(verifyId: String, code: String, completion: @escaping (Result<String, AuthErrorCode>) -> Void) {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyId, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error as? AuthErrorCode {
                completion(Result.failure(error))
            }
            
            result?.user.getIDToken { token, error in
                if let error = error as? AuthErrorCode {
                    completion(Result.failure(error))
                }
                completion(Result.success(token ?? ""))
            }
        }
        
    }
    
}

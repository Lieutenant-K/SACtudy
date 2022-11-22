//
//  FirebaseManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/22.
//

import Foundation
import FirebaseAuth
import RxSwift

enum FirebaseResult {
    
    case success(String)
    case error(AuthErrorCode)
    
}

protocol FirebaseManager {}

extension FirebaseManager {
    
    func requestAuthCode(phoneNumber: String) -> Observable<FirebaseResult> {
        
        Observable.create { observer in
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                
                if let error = error as? AuthErrorCode {
                    observer.onNext(.error(error))
                    return
                }
                
                if let verificationID {
                    UserRepository.shared.personalInfo.phoneNumber = phoneNumber
                    observer.onNext(.success(verificationID))
                }
                
            }
            
            return Disposables.create()
        }
        
    }
    
    func authorizeWithCode(verifyId: String, code: String) -> Observable<FirebaseResult> {
        
        Observable.create { observer in
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyId, verificationCode: code)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                if let error = error as? AuthErrorCode {
                    observer.onNext(.error(error))
                    return
                }
                
                result?.user.getIDToken { token, error in
                    
                    if let error = error as? AuthErrorCode {
                        observer.onNext(.error(error))
                        return
                    }
                    
                    if let token {
                        Constant.idtoken = token
                        observer.onNext(.success(Constant.idtoken))
                    }
                    
                }
            }
            
            return Disposables.create()
            
        }
        
    }
    
    func refreshToken(completion: @escaping () -> Void) {
        
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error {
                print("Firebase IdToken 재발급 에러: ", error)
                return
            }
            
            if let idToken {
                Constant.idtoken = idToken
                completion()
            }
        }
        
    }
    
    
}


extension AuthErrorCode {
    
    var errorMessage: String {
        switch code {
        case .invalidPhoneNumber:
            return "잘못된 전화번호 형식입니다."
        case .tooManyRequests:
            return "과도한 인증 시도가 있었습니다.\n나중에 다시 시도해 주세요."
        case .invalidVerificationCode, .sessionExpired:
            return "전화 번호 인증 실패"
        case .networkError:
            return Constant.networkDisconnectMessage
        default:
            return "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
        }
    }
    
}

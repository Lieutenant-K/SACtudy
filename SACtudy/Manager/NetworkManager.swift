//
//  NetworkManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    static func requestLogin(token: String) -> Observable<Result<User, SeSACError>> {
        
        Constant.idtoken = token
        
        return createSeSACDecodable(router: .login, type: User.self)
    }
    
    static func requestSignUp(data: SignUpData) -> Observable<SeSACResponse>{
        
        let isValidate = data.gender >= 0
        
        if !isValidate {
            return Observable.create { observer in
                observer.onNext(SeSACResponse.failure(.noResponse))
                observer.onCompleted()
                
                return Disposables.create()
            }
        }
        
        return Self.createSeSACRequest(router: Router.signUp(data: data))
    }
    
    static func createSeSACDecodable<T: Decodable>(router: Router, type: T.Type) -> Observable<Result<T, SeSACError>> {
        
        Observable.create { observer in
            
            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.failure(.networkDisconnected))
                observer.onCompleted()
            }
            
            let request = AF.request(router).responseDecodable(of: T.self) { response in
                
                guard let code = response.response?.statusCode else {
                    observer.onNext(Result.failure(.noResponse))
                    return
                }
                
                switch response.result {
                case .success(let data):
                    observer.onNext(Result.success(data))
                case .failure(_):
//                    print("Login Error Description: ", error.errorDescription)
                    if let loginError = SeSACError(rawValue: code) {
                        observer.onNext(.failure(loginError))
                    } else {
                        observer.onNext(.failure(.otherError))
                    }
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    
    static func createSeSACRequest(router: Router) -> Observable<SeSACResponse> {
        
        return Observable<SeSACResponse>.create { observer in

            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.failure(.networkDisconnected))
                observer.onCompleted()
            }
            
            let request = AF.request(router)
            
            request.response { response in
                
                guard let code = response.response?.statusCode else {
                    observer.onNext(.failure(.noResponse))
                    return
                }
                
                if let error = SeSACError(rawValue: code) {
                    if error == .tokenError {
                        FirebaseAuthManager.refreshToken {
                            observer.onNext(.failure(error))
                        }
                    } else {
                        observer.onNext(.failure(error))
                    }
                    return
                }
                
                observer.onNext(.success(code))
                
            }

            return Disposables.create {
                request.cancel()
            }
        }
        
    }
    
}

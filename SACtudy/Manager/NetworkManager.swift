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
    
    /*
    func requestSignup() -> DataRequest {
        
        let url = EndPoint.user(.signUp).url
        
        let token = UserDefaults.standard.string(forKey: "idtoken") ?? ""
        
        let parameter: Parameters = [
            "phoneNumber":UserDefaults.standard.string(forKey: "phoneNumber") ?? "",
            "FCMtoken":UserDefaults.standard.string(forKey: "fcmToken") ?? "",
            "nick":UserDefaults.standard.string(forKey: "nickname") ?? "",
            "birth":UserDefaults.standard.string(forKey: "birth") ?? "",
            "email":UserDefaults.standard.string(forKey: "email") ?? "",
            "gender":UserDefaults.standard.integer(forKey: "gender")
         ]
        
        let header: HTTPHeaders = ["idtoken":token]
        
        return AF.request(url, method: .post, parameters: parameter, headers: header)
        
    }
    
    func requestLogin(token: String) -> DataRequest {
        
        let url = EndPoint.user(.login).url
 
        let header: HTTPHeaders = ["idtoken":token]
        
        return AF.request(url, method: .get, headers: header)
            
    }
    */
    
    static func requestLogin(token: String) -> Observable<Result<User, SeSACError>> {
        
        Constant.idtoken = token
        
        return createSeSACDecodable(router: .login, request: User.self)
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
    
    static func createSeSACDecodable<T: Decodable>(router: Router, request: T.Type) -> Observable<Result<T, SeSACError>> {
        
        Observable.create { observer in

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

//            let request = AF.request("http://api.sesac.co.kr:1207/v1/user", method: router.method, parameters: router.parameters, headers: router.header)
            
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

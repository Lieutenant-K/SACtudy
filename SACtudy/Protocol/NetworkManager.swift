//
//  NetworkManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/22.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkManager: FirebaseManager {}

extension NetworkManager {
    
    func createSeSACDecodable<T: Decodable>(router: Router, type: T.Type) -> Observable<Result<T, APIError>> {
        
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
                    
                    if code == APIError.tokenError.statusCode {
                        refreshToken {
                            observer.onNext(.failure(.tokenError))
                        }
                    } else if code == APIError.clientError.statusCode {
                        observer.onNext(.failure(.clientError))
                    } else if code == APIError.serverError.statusCode {
                        observer.onNext(.failure(.serverError))
                    } else {
                        observer.onNext(.failure(.uniqueError(code)))
                    }

                }
                
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func request<T: Decodable>(router: Router, type: T.Type) -> Observable<APIResult<T>> {
        
        Observable.create { observer in
            
            if !NetworkMonitor.shared.isConnected {
                observer.onNext(.error(.network))
                observer.onCompleted()
            }
            
            let request = AF.request(router).responseDecodable(of: T.self) { response in
                
                guard let code = response.response?.statusCode else {
                    observer.onNext(.error(.noResponse))
                    return
                }
                
                if let data = response.value {
                    observer.onNext(.success(data))
                } else if let error = APIErrors(rawValue: code) {
                    
                    if error == .tokenError {
                        refreshToken {
                            observer.onNext(.error(error))
                            return
                        }
                    } else {observer.onNext(.error(error))}
                    
                } else if code == 200 {
                    observer.onNext(.success(nil))
                } else {
                    observer.onNext(.status(code))
                }
            
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
     
}

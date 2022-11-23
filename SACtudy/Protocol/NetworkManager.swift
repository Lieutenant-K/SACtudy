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

//
//  LaunchViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/20.
//

import Foundation
import RxCocoa
import RxSwift

class LaunchViewModel: ViewModel {
    
    enum LaunchResult {
        
        case success, notRegisterd, networkDisconnect, authRequried
        
    }
    
    struct Input {
        let viewDidAppear: ControlEvent<Bool>
        
    }
    
    struct Output {
        let launchResult = PublishRelay<LaunchResult>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let tryLogin = PublishRelay<String>()
        
        tryLogin.flatMapLatest { token in
            NetworkManager.requestLogin(token: token)}
        .bind { result in
            switch result {
            case .success(let user):
//                Constant.userInfo = user
                output.launchResult.accept(.success)
//                print(Constant.userInfo)
                
            case .failure(let error):
                if error == .notRegistered {
                    output.launchResult.accept(.notRegisterd)
                } else if error == .tokenError {
                    tryLogin.accept(Constant.idtoken)
                }
            }
        }
        .disposed(by: disposeBag)
        
        input.viewDidAppear.bind { _ in
            let token = Constant.idtoken
            if token.isEmpty {
                output.launchResult.accept(.authRequried)
            } else {
                tryLogin.accept(token)
            }
        }
        .disposed(by: disposeBag)
        
        return output
    }
    
    
    
}

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
    struct Input {
        let viewDidAppear: ControlEvent<Bool>
    }
    
    struct Output {
        let loginResult = PublishRelay<UserRepository.LoginResult>()
        let isAuthNeeded = PublishRelay<Transition>()
        let errorMessage = PublishRelay<String>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        UserRepository.shared.loginResult
            .bind(to: output.loginResult)
            .disposed(by: disposeBag)
        
        UserRepository.shared.loginResult
            .map { $0.message }
            .bind(to: output.errorMessage)
            .disposed(by: disposeBag)
        
        input.viewDidAppear
            .bind { _ in
                if !Constant.wasOnboarded {
                    Constant.wasOnboarded = true
                    output.isAuthNeeded.accept(.toOnboarding)
                }
                else if Constant.idtoken.isEmpty { output.isAuthNeeded.accept(.toAuthScene) }
                else { UserRepository.shared.tryLogin() }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension LaunchViewModel {
    enum Transition {
        case toOnboarding, toAuthScene
    }
}

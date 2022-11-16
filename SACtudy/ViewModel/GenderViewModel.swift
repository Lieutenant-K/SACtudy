//
//  GenderViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

enum SignUpResult: Int {
    
    case success = 200
    case alreadyRegistered = 201
    case notAllowedNickname = 202
    
}

class GenderViewModel: ViewModel {
    
    struct Input {
        let manTap: ControlEvent<Void>
        let womanTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let selected: Observable<Int>
        let signUpResult = PublishRelay<SignUpResult>()
        let errorMsg = PublishRelay<String>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let man = input.manTap.map { 1 }
        let woman = input.womanTap.map { 0 }
        let select = Observable.merge([man, woman]).map{$0}
        
        let output = Output(selected: select)
        
        select
            .bind { SignUpData.gender = $0 }
            .disposed(by: disposeBag)
        
        let trySignUp = PublishRelay<Void>()
        
        input.nextButtonTap
            .bind { trySignUp.accept(()) }
            .disposed(by: disposeBag)
        
        trySignUp
            .map { let data = SignUpData.self
                return SignUpData(
                    phoneNumber: data.phoneNumber,
                    nickname: data.nickname,
                    birth: data.birth,
                    email: data.email,
                    gender: data.gender,
                    FCMToken: Constant.FCMtoken) }
            .flatMapLatest { NetworkManager.requestSignUp(data: $0) }
            .subscribe { response in
                switch response {
                case .success(let code):
                    let result = SignUpResult(rawValue: code)!
                    if result == .alreadyRegistered {
                        output.errorMsg.accept("이미 등록된 회원입니다")
                    }
                    output.signUpResult.accept(result)
                case .failure(let error):
                    if error == .tokenError {
                        trySignUp.accept(())
                    } else if error == .networkDisconnected {
                        output.errorMsg.accept(Constant.networkDisconnectMessage)
                    }
                    print(error.message) }
            }
            .disposed(by: disposeBag)
        
        return output
    }
}


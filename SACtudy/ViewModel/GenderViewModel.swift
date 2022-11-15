//
//  GenderViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

class GenderViewModel: ViewModel {
    
    struct Input {
        let manTap: ControlEvent<Void>
        let womanTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let selected: Observable<Int>
        let signUp: Observable<SeSACResponse>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let man = input.manTap.map { 1 }
        let woman = input.womanTap.map { 0 }
        let select = Observable.merge([man, woman]).map{$0}
        
        select
            .bind { SignUpData.gender = $0 }
            .disposed(by: disposeBag)
        
        
        let signUp = input.nextButtonTap
            .map { let data = SignUpData.self
                return SignUpData(
                    phoneNumber: data.phoneNumber,
                    nickname: data.nickname,
                    birth: data.birth,
                    email: data.email,
                    gender: data.gender,
                    FCMToken: Constant.FCMtoken) }
            .flatMapLatest { NetworkManager.requestSignUp(data: $0) }
        
        return Output(selected: select, signUp: signUp)
    }
}


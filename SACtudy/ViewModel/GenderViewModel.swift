//
//  GenderViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

class GenderViewModel: ViewModel, NetworkManager {
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let manTap: ControlEvent<Void>
        let womanTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let selected = PublishRelay<Int>()
        let signUpResult = PublishRelay<UserRepository.SignUpResult>()
        let errorMsg = PublishRelay<String>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let man = input.manTap.map { 1 }
        let woman = input.womanTap.map { 0 }
        
        let output = Output()
        
        Observable.merge([man, woman])
            .bind(to: output.selected)
            .disposed(by: disposeBag)
        
        Observable.merge([man, woman])
            .bind { UserRepository.shared.personalInfo.gender = $0 }
            .disposed(by: disposeBag)
        

        input.viewWillAppear
            .compactMap { _ in UserRepository.shared.personalInfo.gender}
            .bind(to: output.selected)
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .subscribe { _ in
                UserRepository.shared.trySignUp()
            }
            .disposed(by: disposeBag)
        
        UserRepository.shared.signUpResult
            .bind(to: output.signUpResult)
            .disposed(by: disposeBag)
        
        UserRepository.shared.signUpResult
            .compactMap { $0.message }
            .bind(to: output.errorMsg)
            .disposed(by: disposeBag)
        
        return output
    }
}


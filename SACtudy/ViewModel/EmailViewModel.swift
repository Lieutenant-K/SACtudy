//
//  EmailViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

class EmailViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let isValidate = BehaviorRelay<Bool>(value: false)
        let checkEmail = PublishRelay<Bool>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.viewWillAppear
            .compactMap { _ in UserRepository.shared.personalInfo.email }
            .bind(to: input.text)
            .disposed(by: disposeBag)
        
        input.text
            .orEmpty
            .bind { UserRepository.shared.personalInfo.email = $0 }
            .disposed(by: disposeBag)
        
        input.text
            .orEmpty
            .map { $0.isEmailFormat }
            .bind(to: output.isValidate)
            .disposed(by: disposeBag)
            
 
        input.nextButtonTap
            .map { output.isValidate.value }
            .bind(to: output.checkEmail)
            .disposed(by: disposeBag)
        
        return output
    }
    
}

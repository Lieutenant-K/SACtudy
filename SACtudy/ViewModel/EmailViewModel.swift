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
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let isValidate: Observable<Bool>
        let checkEmail: Observable<(isValid: Bool, email: String)>
    }
    
    var isValidate = false

    var email: String = ""
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.text
            .orEmpty
            .withUnretained(self)
            .bind { $0.email = $1 }
            .disposed(by: disposeBag)
        
        let valid = input.text
            .orEmpty
            .map { let regex = #"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"#
                return $0.range(of: regex, options: .regularExpression) != nil }
        
        valid
            .withUnretained(self)
            .bind { $0.isValidate = $1 }
            .disposed(by: disposeBag)
            
 
        let check = input.nextButtonTap
            .withUnretained(self)
            .map { model, _ in
                (isValid: model.isValidate, email: model.email)
            }
        
        return Output(isValidate: valid, checkEmail: check)
    }
    
}

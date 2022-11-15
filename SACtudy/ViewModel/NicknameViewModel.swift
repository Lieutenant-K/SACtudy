//
//  NicknameViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel: ViewModel {
    
    struct Input {
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let nickname: Observable<String>
        let isValidate: Observable<Bool>
        let checkNickname: Observable<(isValid: Bool, nickname: String)>
    }
    
    var isValidate = false
    
    var nickname = ""
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let text = input.text
            .orEmpty
            .map { $0.substring(from: 0, to: $0.count > 10 ? 10 : $0.count) }
        
        let valid = text.map { $0.count > 0 && $0.count < 11 }
        
        let check = input.nextButtonTap
            .withUnretained(self)
            .map { vc, _ in
                (isValid: vc.isValidate, nickname: vc.nickname)
            }
        
        text
            .withUnretained(self)
            .bind { $0.nickname = $1 }
            .disposed(by: disposeBag)
        
        valid
            .withUnretained(self)
            .bind { $0.isValidate = $1 }
            .disposed(by: disposeBag)
        
        return Output(nickname: text, isValidate: valid, checkNickname: check)
    }
    
}

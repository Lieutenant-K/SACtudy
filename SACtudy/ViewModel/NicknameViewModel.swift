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
        let viewWillAppear: ControlEvent<Bool>
        let text: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let nickname = PublishRelay<String>()
        let isValidate = BehaviorRelay<Bool>(value: false)
        let checkNickname = PublishRelay<Bool>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.viewWillAppear
            .compactMap { _ in UserRepository.shared.personalInfo.nickname }
            .bind(to: input.text)
            .disposed(by: disposeBag)
        
        input.text
            .orEmpty
            .map { $0.substring(from: 0, to: $0.count > 10 ? 10 : $0.count)}
            .bind {
                UserRepository.shared.personalInfo.nickname = $0
                output.nickname.accept($0)
            }
            .disposed(by: disposeBag)
        
        input.text
            .orEmpty
            .map { $0.count > 0 && $0.count < 11 }
            .bind(to: output.isValidate)
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .map { output.isValidate.value }
            .bind(to: output.checkNickname)
            .disposed(by: disposeBag)
        
        return output
    }
    
}

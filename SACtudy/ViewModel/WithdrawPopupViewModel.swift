//
//  WithdrawPopupViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/22.
//

import Foundation
import RxCocoa
import RxSwift

class WithdrawPopupViewModel: ViewModel {
    
    struct Input {
        let okButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let withdrawResult = PublishRelay<UserRepository.WithdrawResult>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.okButtonTap
            .subscribe { _ in
                UserRepository.shared.requestWithdraw() }
            .disposed(by: disposeBag)
        
        UserRepository.shared.withdrawResult
            .bind(to: output.withdrawResult)
            .disposed(by: disposeBag)
        
        return output
        
    }
    
    
}

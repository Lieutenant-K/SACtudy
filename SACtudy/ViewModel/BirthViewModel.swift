//
//  BirthViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxCocoa
import RxSwift

class BirthViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let date: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
        let year: ControlProperty<String?>
        let month: ControlProperty<String?>
        let day: ControlProperty<String?>
    }
    
    struct Output {
        let component = PublishRelay<DateComponents>()
        let isValidate = BehaviorRelay<Bool>(value: false)
        let check = PublishRelay<Bool>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let date = BehaviorRelay<Date>(value: Date())
        
        
        Observable.just(UserRepository.shared.personalInfo.birth?.toBirthDate ?? Date())
            .subscribe(input.date)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .map { _ in UserRepository.shared.personalInfo.birth?.toBirthDate ?? Date() }
            .bind(to: date)
            .disposed(by: disposeBag)
        
        input.date
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date
            .map { $0.toBirthString }
            .bind { UserRepository.shared.personalInfo.birth = $0 }
            .disposed(by: disposeBag)
        
        date
            .map { $0.birthComponent }
            .bind { compo in
                let bool = compo.year != nil && compo.month != nil && compo.day != nil
                output.component.accept(compo)
                output.isValidate.accept(bool) }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .map { output.isValidate.value && UserRepository.shared.personalInfo.birth?.toBirthDate?.currentAge ?? 0 >= 17 }
            .bind(to: output.check)
            .disposed(by: disposeBag)
        
        
        return output
        
    }
    
}

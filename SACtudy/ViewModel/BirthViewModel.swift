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
        let date: ControlProperty<Date>
        let nextButtonTap: ControlEvent<Void>
        let year: ControlProperty<String?>
        let month: ControlProperty<String?>
        let day: ControlProperty<String?>
    }
    
    struct Output {
        let component: Observable<DateComponents>
        let isValidate: Observable<Bool>
        let check: Observable<(isValid: Bool, date: String)>
    }
    
    var age: Int = (SignUpData.birth.toBirthDate?.currentAge ?? 0 )
    var birthString = SignUpData.birth
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.date
            .map { $0.toBirthString }
            .bind { SignUpData.birth = $0 }
            .disposed(by: disposeBag)
        
        let date = input.date
            .map { Calendar(identifier: .iso8601)
                .dateComponents([.year, .month, .day], from: $0) }
        
        let valid = date.map {
            $0.year != nil && $0.month != nil && $0.day != nil }
        
        let check = input.nextButtonTap
            .map { _ in
                
                let birth = SignUpData.birth
                let valid = birth.toBirthDate?.currentAge ?? 0 >= 17
                
                return (isValid: valid, date: birth) }
        
        
        return Output(component: date, isValidate: valid, check: check)
        
    }
    
}

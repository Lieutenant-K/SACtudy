//
//  AuthViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa

class AuthPhoneViewModel: ViewModel, FirebaseManager {
    
    struct Input {
        let text: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumber: Observable<String>
        let isValidate: Observable<Bool>
        let phoneAuthResult = PublishRelay<String>()
        let toastMessage = PublishRelay<String>()
    }
    
    var isValidate = false
    var number = ""
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let numbers = input.text
            .orEmpty
            .withUnretained(self)
            .flatMapLatest { model, text in
                model.inputText(text: text)
            }
        
        let valid = numbers
            .map{
                let text = $0.joined()
                return text[0] == "0" && text[1] == "1" && text.count >= 10
            }
    
        let phone = numbers.map { $0.joined(separator: "-") }
        
        let output = Output(phoneNumber: phone, isValidate: valid)
        
        let requestAuthCode = PublishRelay<Void>()
        
        input.text.orEmpty
            .map { $0.split(separator: "-").joined() }
            .bind(with: self) { model, string in
                model.number = "+82" + (string.count > 1 ? string.substring(from: 1, to: string.count) : "") }
            .disposed(by: disposeBag)

        
        
        valid
            .withUnretained(self)
            .bind { $0.isValidate = $1 }
            .disposed(by: disposeBag)
        
        input.buttonTap
            .withUnretained(self)
            .bind { model, _ in
                if model.isValidate {
                    output.toastMessage.accept("전화 번호 인증 시작")
                    requestAuthCode.accept(())
                }
                else {
                    output.toastMessage.accept("잘못된 전화번호 형식입니다.")
                }
            }
            .disposed(by: disposeBag)
        
        
        requestAuthCode
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.requestAuthCode(phoneNumber: model.number)}
            .subscribe { result in
                switch result {
                case let .success(id):
                    output.phoneAuthResult.accept(id)
                case let .error(error):
                    output.toastMessage.accept(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)
        
        return output
        
    }
    
    func inputText(text: String) -> Observable<[String]> {
        
        return Observable<[String]>.create { observer in
            
            var ranges: [(Int, Int)] = []
            let str = text.filter { $0.isNumber }
            let count = str.count
            
            if count <= 3 {
                ranges = [(0,count)]
            } else if count < 7 {
                ranges = [ (0, 3), (3, count) ]
            } else if count < 11 {
                ranges = [ (0, 3), (3, 6), (6, count) ]
            } else {
                ranges = [ (0, 3), (3, 7), (7, 11) ]
            }
            
            let subNumbers = ranges
                .map { str.substring(from: $0.0, to: $0.1) }
            
            observer.onNext(subNumbers)
            
            return Disposables.create()
            
        }
        
    }
    
}


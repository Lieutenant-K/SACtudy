//
//  AuthViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class AuthPhoneViewModel {
    
    var isValidate = false
    
    var number = ""
    
    let phoneNumber = PublishRelay<String>()

    let validation = BehaviorRelay<Bool>(value: false)
    
    let errorMessage = PublishRelay<String>()
    
    func inputText(text: String) {
        
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
        
        number = subNumbers.joined()
        
        phoneNumber.accept(subNumbers.joined(separator: "-"))
        
    }
    
    func checkValidation() {
        
        let valid = (number[0] == "0" && number[1] == "1" && number.count >= 10)
        
        isValidate = valid
        
        validation.accept(isValidate)
        
    }
    
    func requestSMSCode(completion: @escaping (_ id: String) -> ()) {
        
        if !isValidate {
            errorMessage.accept("잘못된 전화번호 형식입니다.")
            return
        }
        
        errorMessage.accept("전화 번호 인증 시작")
        
        let authNumber = "+82" + number.substring(from: 1, to: number.count)
        
        FirebaseAuthManager.shared.requestAuthCode(phoneNumber: authNumber) { [weak self] result in
            
            switch result {
            case .failure(let error):
                self?.errorMessage.accept(error.errorMessage)
            case.success(let id):
                completion(id)
            }
            
        }
    }
    
}


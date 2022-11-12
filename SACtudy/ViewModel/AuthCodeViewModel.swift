//
//  AuthCodeViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class AuthCodeViewModel {
    
    let verificationId: String
    
    var isValidate = false
    
    var codeNumber = ""
    
    let code = PublishRelay<String>()

    let validation = BehaviorRelay<Bool>(value: false)
    
    let errorMessage = PublishRelay<String>()
    
    func inputCode(text: String) {
        
        let str = text.filter { $0.isNumber }
        let count = str.count
        
        let number = str.substring(from: 0, to: count > 6 ? 6 : count)
        
        codeNumber = number
        
        code.accept(codeNumber)
        
    }
    
    func checkValidation() {
        
        isValidate = codeNumber.count == 6
        
        validation.accept(isValidate)
        
    }
    
    func authorize(completion: @escaping (_ token: String) -> Void) {
        
        if !isValidate {
            errorMessage.accept("전화 번호 인증 실패")
            return
        }
        
        FirebaseAuthManager.shared.authorizeWithCode(verifyId: verificationId, code: codeNumber) { result in
            
            switch result {
            case .success(let token):
                print(token)
            case .failure(let error):
                
                print(error.errorCode, error.localizedDescription)
                print(error.code)
            }
            
        }
        
//        errorMessage.accept("전화 번호 인증 시작")
        
    }
    
    init(verificationId: String) {
        self.verificationId = verificationId
    }
    
}

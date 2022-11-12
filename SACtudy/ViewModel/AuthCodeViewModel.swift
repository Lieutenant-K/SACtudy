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
    
    var restTime = 60
    
    let code = PublishRelay<String>()

    let validation = BehaviorRelay<Bool>(value: false)
    
    let errorMessage = PublishRelay<String>()
    
    lazy var countDown = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        .withUnretained(self)
        .map { model, value in model.restTime - (value+1) }
        .take(until: { $0 <= 0 }, behavior: .exclusive)

    
    func inputCode(text: String){
        
        
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
        
        FirebaseAuthManager.shared.authorizeWithCode(verifyId: verificationId, code: codeNumber) { [weak self] result in
            
            switch result {
            case .success(let token):
                completion(token)
            case .failure(let error):
                self?.errorMessage.accept(error.errorMessage)
//                print(error.errorCode, error.localizedDescription)
                
            }
            
        }
        
    }
    
    init(verificationId: String) {
        self.verificationId = verificationId
        
    }
    
    deinit {
        
    }
    
}

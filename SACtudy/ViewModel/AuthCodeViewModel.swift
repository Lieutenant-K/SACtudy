//
//  AuthCodeViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import Foundation
import RxSwift
import RxCocoa

class AuthCodeViewModel: ViewModel, FirebaseManager {
    
    struct Input {
        let text: ControlProperty<String?>
        let authButtonTap: ControlEvent<Void>
        let resendMsgButtonTap: ControlEvent<Void>
        let viewDidAppear: ControlEvent<Bool>
    }
    
    struct Output {
        let code: Observable<String>
        let isValidate: Observable<Bool>
        let resetTimer: Observable<Int>
        let error = PublishRelay<String>()
        let loginResult = PublishRelay<UserRepository.LoginResult>()
    }
    
    let verificationId: String
    var codeNumber = ""
    var restTime = 60
    var isValidate: Bool {
        codeNumber.count == 6
    }
    
    func createTimer() -> Observable<Int> {
        
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { $0.restTime - ($1+1) }
            .take(until: { $0 <= 0 }, behavior: .exclusive)
        
    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
         
        let code = input.text
            .orEmpty
            .map { text in
                let code = text.filter { $0.isNumber }
                return code.substring(from: 0, to: code.count > 6 ? 6 : code.count)
            }
        
        let valid = code.map { $0.count == 6 }
        
        let resetTimer = Observable<Void>.merge([
            input.viewDidAppear.map {_ in },
            input.resendMsgButtonTap.map {_ in }
        ])
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.createTimer()
            }
        
        let output = Output(code: code, isValidate: valid, resetTimer: resetTimer)
        
        let tryGetToken = PublishRelay<Void>()
        
        input.authButtonTap
            .bind(with: self) { model, _ in
                if model.isValidate {
                    tryGetToken.accept(())
                }
                else {
                    output.error.accept("전화 번호 인증 실패")
                }
            }
            .disposed(by: disposeBag)
        
        tryGetToken
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.authorizeWithCode(verifyId: model.verificationId, code: model.codeNumber) }
            .subscribe { result in
                switch result {
                case let .error(error):
                    output.error.accept(error.errorMessage)
                case let .success(token):
                    print("파이어베이스 로그인 용 토큰: ",token)
                    UserRepository.shared.tryLogin() }
            }
            .disposed(by: disposeBag)
        
        UserRepository.shared.loginResult
            .bind(to: output.loginResult)
            .disposed(by: disposeBag)
        
        UserRepository.shared.loginResult
            .map { $0.message }
            .bind(to: output.error)
            .disposed(by: disposeBag)
        
        
        code.withUnretained(self)
            .bind { $0.codeNumber = $1 }
            .disposed(by: disposeBag)
        
        return output
    }

    init(verificationId: String) {
        self.verificationId = verificationId
    }
    
    deinit {
        
    }
    
}

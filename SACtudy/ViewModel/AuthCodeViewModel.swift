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
import Alamofire

enum LoginResult {
    
    case success(User)
    case notRegistered
    
}

class AuthCodeViewModel: ViewModel {
    
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
        let loginResult = PublishRelay<LoginResult>()
    }
    
    let verificationId: String
    
    var isValidate: Bool {
        codeNumber.count == 6
    }
    
    var codeNumber = ""
    
    var restTime = 60
    
    let errorMessage = PublishRelay<String>()
    
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
        
//        let errorMsg = PublishRelay<String>()
        let tryLogin = PublishRelay<String>()
        let tryGetToken = PublishRelay<Void>()
        
        input.authButtonTap
            .withUnretained(self)
            .map { model, _ in model.isValidate }
            .bind { isValidate in
                if isValidate {
                    tryGetToken.accept(()) }
                else {
                    output.error.accept("전화 번호 인증 실패") }
            }
            .disposed(by: disposeBag)
        
        tryGetToken
            .withUnretained(self)
            .flatMapLatest { model, _ in
                FirebaseAuthManager.shared.authorizeWithCode(verifyId: model.verificationId, code: model.codeNumber) }
            .subscribe { result in
                switch result {
                case .failure(let error):
                    output.error.accept(error.errorMessage)
                case .success(let token):
                    print("파이어베이스 로그인 용 토큰: ",token)
                    tryLogin.accept(token) }
            }
            .disposed(by: disposeBag)
        
        tryLogin.flatMapLatest {
            NetworkManager.requestLogin(token: $0) }
        .subscribe { result in
            switch result {
            case .success(let user):
                output.loginResult.accept(.success(user))
            case .failure(let error):
                if error == .tokenError {
                    tryLogin.accept(Constant.idtoken)
                } else if error == .notRegistered {
                    output.error.accept("등록되지 않은 회원입니다\n회원가입을 진행합니다")
                    output.loginResult.accept(.notRegistered)
                } else if error == .networkDisconnected {
                    output.error.accept(Constant.networkDisconnectMessage)
                }
                print(error.message)
            }
        }
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

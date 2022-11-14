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
        let error: PublishRelay<String>
        let login: Observable<Result<User,LoginError>>
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
    
    func requestToken(id: String, code: String) -> Observable<Result<String, AuthErrorCode>> {
        
        Observable<Result<String, AuthErrorCode>>.create { observer in
            
            FirebaseAuthManager.shared.authorizeWithCode(verifyId: id, code: code) { result in
                observer.onNext(result)
            }
            
            return Disposables.create()
            
        }

    }
    
    
    func requestLogin(token: String) -> Observable<Result<User, LoginError>> {

        Observable.create { observer in

            let request = NetworkManager.shared.requestLogin(token: token).responseDecodable(of: User.self) { response in

                guard let code = response.response?.statusCode else {
                    observer.onNext(Result.failure(LoginError.networkingError))
                    return
                }

                switch response.result {
                case .success(let user):
                    observer.onNext(Result.success(user))
                case .failure(let error):
                    print("Login Error Description: ", error.errorDescription)
                    let loginError = LoginError(rawValue: code)!
                    
                    if loginError == .unregisterdUser {
                        UserDefaults.standard.set(token, forKey: "idtoken")
                    }
                    
                    observer.onNext(.failure(loginError))
                }

            }

            return Disposables.create {
                request.cancel()
            }
        }

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
        
        let errorMsg = PublishRelay<String>()
        let login = PublishRelay<String>()
        let token = PublishRelay<Void>()
        
        input.authButtonTap
            .withUnretained(self)
            .map { model, _ in model.isValidate }
            .bind {
                if $0 { token.accept(()) }
                else { errorMsg.accept("전화 번호 인증 실패") }
            }
            .disposed(by: disposeBag)
        
        token
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.requestToken(id: model.verificationId, code: model.codeNumber)
            }
            .subscribe { result in
                switch result {
                case .failure(let error):
                    errorMsg.accept(error.errorMessage)
                case .success(let token):
                    print("파이어베이스 로그인 용 토큰: ",token)
                    login.accept(token)
                }
            }
            .disposed(by: disposeBag)
        
        code.withUnretained(self)
            .bind { $0.codeNumber = $1 }
            .disposed(by: disposeBag)
        
        return Output(
            code: code,
            isValidate: valid,
            resetTimer: resetTimer,
            error: errorMsg,
            login: login.withUnretained(self)
                .flatMapLatest { model, token in
                    model.requestLogin(token: token)
                }
        )
        
        
    }

    init(verificationId: String) {
        self.verificationId = verificationId
        
    }
    
    deinit {
        
    }
    
}

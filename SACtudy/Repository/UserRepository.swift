//
//  UserRepository.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/20.
//

import Foundation
import RxSwift
import RxCocoa

struct PersonalInfomation {
    
    var phoneNumber: String? {
        get {UserDefaults.standard.string(forKey: "phoneNumber") }
        set {UserDefaults.standard.setValue(newValue, forKey: "phoneNumber")}
    }
    var nickname: String?
    var birth: String?
    var email: String?
    var gender: Int?
    var FCMtoken: String? = Constant.FCMtoken
    
}

class UserRepository: NetworkManager {
    
    enum LoginResult {
        case success(User?), unregistered, networkError
        
        var message: String {
            switch self {
            case .success:
                return "로그인 성공"
            case .unregistered:
                return "등록되지 않은 회원입니다!"
            case .networkError:
                return Constant.networkDisconnectMessage
            }
        }
    }
    
    enum SignUpResult: Int {
        case success = 200
        case alreadySigned = 201
        case notAvailableNickname = 202
        case unregistered = 406
        case networkError = -1
        
        var message: String? {
            switch self {
            case .alreadySigned:
                return "이미 가입된 회원입니다"
            case .networkError:
                return Constant.networkDisconnectMessage
            case .unregistered:
                return "등록되지 않은 회원입니다"
            default:
                return nil
            }
        }
    }
    
    static let shared = UserRepository()
    
    private init() {
        binding()
    }
    
    private var userInfo: User?
    
    private let disposeBag = DisposeBag()
    
    lazy var personalInfo = PersonalInfomation()
    
    let loginResult = PublishRelay<LoginResult>()
    let signUpResult = PublishRelay<SignUpResult>()
    
    /// 변경 필요
    let updateResult = PublishRelay<Result<Empty, APIError>>()
    let withdrawResult = PublishRelay<Result<Empty, APIError>>()
    ///
    
    let login = PublishRelay<String>()
    let signUp = PublishRelay<PersonalInfomation>()
    let update = PublishRelay<User.UserSetting>()
    let withdraw = PublishRelay<Void>()
    
    func fetchUserData() -> Observable<User?> {
        
        Observable.just(userInfo)
        
    }
    
    func tryLogin() {
        
//        if userInfo != nil {
//            loginResult.accept(.success)
//            return
//        }
        
        login.accept(Constant.idtoken)
        
    }
    
    func trySignUp() {
        
        if personalInfo.FCMtoken != nil && personalInfo.birth != nil && personalInfo.email != nil && personalInfo.gender != nil && personalInfo.nickname != nil && personalInfo.phoneNumber != nil {
            
            signUp.accept(personalInfo)
            
        }
        
    }
    
    func requestWithdraw() {
        
        withdraw.accept(())
        
    }
    
    private func cleanUserData() {
        
        let userDefault = UserDefaults.standard
        
        userInfo = nil
        personalInfo = PersonalInfomation()
        
        userDefault.removeObject(forKey: "idtoken")
        userDefault.removeObject(forKey: "FCMtoken")
        userDefault.removeObject(forKey: "phoneNumber")
        
    }
    
    private func binding() {
        
        login
            .withUnretained(self)
            .flatMapLatest { model, token in
                model.request(router: .login, type: User.self) }
            .subscribe(with: self) { (repo, result: APIResult<User>) in
                switch result {
                case let .success(user):
                    repo.userInfo = user
                    repo.loginResult.accept(.success(user))
                case .error(.tokenError):
                    repo.login.accept(Constant.idtoken)
                case .error(.network):
                    repo.loginResult.accept(.networkError)
                case .status(406):
                    repo.loginResult.accept(.unregistered)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        signUp
            .withUnretained(self)
            .flatMapLatest { model, info in
                model.request(router: .signUp(data: info), type: User.self) }
            .subscribe(with: self) { (repo, result: APIResult<User>) in
                switch result {
                case let .success(user):
                    repo.userInfo = user
                    repo.signUpResult.accept(.success)
                case .error(.tokenError):
                    repo.signUp.accept(repo.personalInfo)
                case .error(.network):
                    repo.signUpResult.accept(.networkError)
                case let .status(code):
                    if let status = SignUpResult(rawValue: code) {
                        repo.signUpResult.accept(status) }
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        
        update
            .withUnretained(self)
            .flatMapLatest { model, setting in
                model.createSeSACDecodable(router: .updateUserSetting(data: setting), type: Empty.self) }
        .subscribe { [weak self] (result: Result<Empty, APIError>) in
            switch result {
            case .success:
                self?.login.accept(Constant.idtoken)
                self?.updateResult.accept(result)
            case .failure:
                self?.updateResult.accept(result)
            }}
        .disposed(by: disposeBag)
        
        withdraw
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.createSeSACDecodable(router: .withdraw, type: Empty.self) }
        .subscribe(onNext: { [weak self] (result: Result<Empty, APIError>) in
            switch result {
                
            case .success:
                self?.cleanUserData()
                self?.withdrawResult.accept(result)
            case let .failure(error):
                if error == .uniqueError(200) {
                    self?.cleanUserData()
                    self?.withdrawResult.accept(result)
                }
                else if error == .tokenError {
                    self?.requestWithdraw()
                    return
                } else if error == .uniqueError(406) {
                    self?.withdrawResult.accept(result)}
            }
            
        })
        .disposed(by: disposeBag)
        
        
        
    }
    
}

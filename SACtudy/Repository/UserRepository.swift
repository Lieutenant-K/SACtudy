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
    
    enum UpdateResult: Int {
        case success = 200
        case networkError = -1
    }
    
    enum WithdrawResult: Int {
        case success = 200
        case networkError = -1
        case alreadyWithdrawed = 406
        
        var message: String? {
            switch self {
            case .networkError:
                return Constant.networkDisconnectMessage
            case .alreadyWithdrawed:
                return "이미 탈퇴 처리된 회원입니다"
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
    let updateResult = PublishRelay<UpdateResult>()
    let withdrawResult = PublishRelay<WithdrawResult>()
    
    private let login = PublishRelay<String>()
    private let signUp = PublishRelay<PersonalInfomation>()
    private let update = BehaviorRelay<User.UserSetting?>(value: nil)
    private let withdraw = PublishRelay<Void>()
    private let updateFCMToken = PublishRelay<String>()
    
    func fetchUserData() -> Observable<User?> {
        Observable.just(userInfo)
    }
    
    func tryLogin() {
        login.accept(Constant.idtoken)
    }
    
    func trySignUp() {
        if personalInfo.FCMtoken != nil && personalInfo.birth != nil && personalInfo.email != nil && personalInfo.gender != nil && personalInfo.nickname != nil && personalInfo.phoneNumber != nil {
            
            signUp.accept(personalInfo)
        }
    }
    
    func tryUpdate(setting: User.UserSetting) {
        update.accept(setting)
    }
    
    func requestWithdraw() {
        withdraw.accept(())
    }
    
    private func checkNeedToUpdateFCMToken(fcmToken: String) {
        if Constant.FCMtoken != fcmToken {
            updateFCMToken.accept(Constant.FCMtoken)
        }
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
            .flatMapLatest { repo, token in
                repo.request(router: .user(.login), type: User.self) }
            .subscribe(with: self) { (repo, result: APIResult<User>) in
                switch result {
                case let .success(user):
                    if let user {
                        repo.checkNeedToUpdateFCMToken(fcmToken: user.fcMtoken)
                    }
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
            .flatMapLatest { repo, info in
                repo.request(router: .user(.signUp(data: info)), type: User.self) }
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
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { repo, setting in
                repo.request(router: .user(.updateUserSetting(data: setting)), type: Empty.self)}
            .subscribe(with: self) { repo, result in
                switch result {
                case .success:
                    repo.updateResult.accept(.success)
                case .error(.tokenError):
                    repo.update.accept(repo.update.value)
                case .error(.network):
                    repo.updateResult.accept(.networkError)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        
        withdraw
            .withUnretained(self)
            .flatMapLatest { model, _ in
                model.request(router: .user(.withdraw), type: Empty.self) }
            .subscribe(with: self) { repo, result in
                
            switch result {
                
            case .success:
                repo.cleanUserData()
                repo.withdrawResult.accept(.success)
            case .error(.tokenError):
                repo.withdraw.accept(())
            case .error(.network):
                repo.withdrawResult.accept(.networkError)
            case .status(406):
                repo.withdrawResult.accept(.alreadyWithdrawed)
            default:
                print(result)
            }
            
        }
        .disposed(by: disposeBag)
        
        updateFCMToken
            .withUnretained(self)
            .flatMapLatest { repo, token in
                repo.request(router: .user(.updateFCMToken(token: token)), type: Empty.self) }
            .subscribe(with: self) { repo, result in
                switch result {
                case .success:
                    print(" 😇😇😇😇😇😇 FCM 갱신 성공 😇😇😇😇😇😇 ")
                    repo.login.accept(Constant.idtoken)
                case .error(.tokenError):
                    repo.updateFCMToken.accept(Constant.FCMtoken)
                case .error(.network):
                    repo.loginResult.accept(.networkError)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

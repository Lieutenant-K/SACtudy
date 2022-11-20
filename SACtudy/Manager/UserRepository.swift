//
//  UserRepository.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class UserRepository {
    
    static let shared = UserRepository()
    
    private init() {
        binding()
    }
    
    private var userInfo: User?
    
    private let disposeBag = DisposeBag()
    
    let loginResult = PublishRelay<Result<User, APIError>>()
    let updateResult = PublishRelay<Result<Empty, APIError>>()
    
    let login = PublishRelay<String>()
    let update = PublishRelay<User.UserSetting>()
    
    func fetchUserInfo() {
        
        if let userInfo {
            loginResult.accept(.success(userInfo))
            return
        }
        
        login.accept(Constant.idtoken)
        
    }
    
    private func binding() {
        
        login.flatMapLatest { token in
            NetworkManager.requestLogin(token: token) }
        .subscribe { [weak self] result in
            switch result {
            case .success(let user):
                self?.userInfo = user
                self?.loginResult.accept(result)
            case .failure(let error):
                if error == .tokenError {
                    self?.login.accept(Constant.idtoken)
                } else {
                    self?.loginResult.accept(result)
                }
            }
        }
        .disposed(by: disposeBag)
        
        update.flatMapLatest { setting in
            NetworkManager.createSeSACDecodable(router: .updateUserSetting(data: setting), type: Empty.self) }
        .subscribe { [weak self] (result: Result<Empty, APIError>) in
            switch result {
            case .success:
                self?.login.accept(Constant.idtoken)
                self?.updateResult.accept(result)
            case .failure:
                self?.updateResult.accept(result)
            }}
        .disposed(by: disposeBag)
        
    }
    
}

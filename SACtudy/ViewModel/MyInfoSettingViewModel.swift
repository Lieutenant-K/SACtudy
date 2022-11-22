//
//  MyInfoSettingViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/20.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class MyInfoSettingViewModel {
    
    enum UpdateResult {
        
        case success, networkDisconnected
        
    }
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let manButton: ControlEvent<Void>
        let womanButton: ControlEvent<Void>
        let studyText: ControlProperty<String?>
        let searchableSwitch: ControlProperty<Bool>
        let ageSlider: ControlProperty<[CGFloat]>
        let saveButtonTap: ControlEvent<Void>
        
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let nickname = PublishRelay<String>()
        let background = PublishRelay<String>()
        let sesac = PublishRelay<String>()
        let gender = PublishRelay<Int>()
        let study = PublishRelay<String>()
        let searchable = PublishRelay<Bool>()
        let ageRange = PublishRelay<[CGFloat]>()
        let sesacTitles = PublishRelay<[Section]>()
        let updateResult = PublishRelay<UpdateResult>()
        // 정보 최종 저장
    }
    
    var userSetting: User.UserSetting?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        // 유저 정보 가져오기 결과 받기 (네트워킹)
        UserRepository.shared.loginResult
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(user):
                    
                    guard let user else { return }
                    output.nickname.accept(user.nick)
                    output.background.accept("sesac_background_\(user.background)")
                    output.sesac.accept("sesac_face_\(user.sesac)")
                    output.gender.accept(user.gender)
                    output.study.accept(user.study)
                    output.searchable.accept(user.searchable == 1)
                    output.ageRange.accept([CGFloat(user.ageMin), CGFloat(user.ageMax)])
                    
                    let items = user.reputation.enumerated().compactMap { (index, value) in
                        let title = SeSACTitle(rawValue: index)
                        return title == nil ? nil : Item(title: title!.title, count: value)
                    }
                    output.sesacTitles.accept([Section(items: items)])
                    
                    model.userSetting = user.userSetting
                default:
                    output.errorMessage.accept(result.message)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 유저 세팅 업데이트 결과 받기
        UserRepository.shared.updateResult
            .subscribe { [weak self] (result: Result<Empty, APIError>) in
                switch result {
                case .success:
                    output.updateResult.accept(.success)
                case .failure(let error):
                    if error == .uniqueError(200) {
                        output.updateResult.accept(.success)
                    }
                    else if error == .networkDisconnected {
                        output.updateResult.accept(.networkDisconnected)
                    } else if error == .tokenError {
                        if let setting = self?.userSetting {
                            UserRepository.shared.update.accept(setting)
                        }
                    } else { print(error) }
                }
            }
            .disposed(by: disposeBag)
        
        input.manButton
            .map { 1 }
            .bind { [weak self] value in
                self?.userSetting?.gender = value
                output.gender.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.womanButton
            .map { 0 }
            .bind { [weak self] value in
                self?.userSetting?.gender = value
                output.gender.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.studyText
            .orEmpty
            .bind { [weak self] value in
                self?.userSetting?.study = value
                output.study.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.searchableSwitch
            .bind { [weak self] (value: Bool) in
                self?.userSetting?.searchable = value ? 1 : 0
                output.searchable.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.ageSlider
            .bind { [weak self] (values: [CGFloat]) in
                self?.userSetting?.ageMin = Int(values[0])
                self?.userSetting?.ageMax = Int(values[1])
                output.ageRange.accept(values)
            }
            .disposed(by: disposeBag)
        
        // 뷰 등장 시 유저 정보 가져오기 (네트워킹)
        input.viewWillAppear
            .bind { _ in
                // 이미 저장된 유저 데이터를 불러옴
                //                UserRepository.shared.fetchUserInfo()
                
                // 네트워킹을 통해 새로 불러옴
                UserRepository.shared.tryLogin()
            }
            .disposed(by: disposeBag)
        
        
        // 저장 버튼 클릭 시 유저 세팅 저장하기 (네트워킹)
        input.saveButtonTap
            .withUnretained(self)
            .compactMap { model, _ in
                model.userSetting }
            .subscribe { setting in
                UserRepository.shared.update.accept(setting)}
            .disposed(by: disposeBag)
        
        
        return output
        
    }
    
    
}

extension MyInfoSettingViewModel {
    
    struct Item {
        
        let title: String
        let count: Int
        
    }
    
    struct Section: SectionModelType {
        
        var items: [Item]
        
        init(items: [Item]) {
            self.items = items
        }
        
        init(original: MyInfoSettingViewModel.Section, items: [Item]) {
            self = original
            self.items = items
        }
        
    }
    
}

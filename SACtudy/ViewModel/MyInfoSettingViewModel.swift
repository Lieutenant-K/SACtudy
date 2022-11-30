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
        let background = PublishRelay<ImageAsset?>()
        let sesac = PublishRelay<ImageAsset?>()
        let gender = BehaviorRelay<Int?>(value: nil)
        let study = BehaviorRelay<String?>(value: nil)
        let searchable = BehaviorRelay<Bool?>(value: nil)
        let ageRange = BehaviorRelay<[CGFloat]?>(value: nil)
        let sesacTitles = PublishRelay<[Reputation]>()
        let updateResult = PublishRelay<UserRepository.UpdateResult>()
        // 정보 최종 저장
    }
    
//    var userSetting: User.UserSetting?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        // 유저 정보 가져오기 결과 받기 (네트워킹)
        UserRepository.shared.loginResult
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(user):
                    
                    guard let user else { return }
                    
                    output.nickname.accept(user.nick)
                    output.background.accept(Asset.Images.sesacBackground(number: user.background))
                    output.sesac.accept(Asset.Images.sesacFace(number: user.sesac))
                    output.gender.accept(user.gender)
                    output.study.accept(user.study)
                    output.searchable.accept(user.searchable == 1)
                    output.ageRange.accept([CGFloat(user.ageMin), CGFloat(user.ageMax)])
                    output.sesacTitles.accept(model.createSeSACTitleSection(reputation: user.reputation))
                    
//                    model.userSetting = user.userSetting
                default:
                    output.errorMessage.accept(result.message)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 유저 세팅 업데이트 결과 받기
        UserRepository.shared.updateResult
            .subscribe(with: self) { (model, result) in
                switch result {
                case .success:
                    output.updateResult.accept(.success)
                case .networkError:
                    output.errorMessage.accept(Constant.networkDisconnectMessage)
                }
            }
            .disposed(by: disposeBag)
        
        let man = input.manButton.map {1}
        let woman = input.womanButton.map {0}
        
        Observable.merge([man, woman])
            .bind(to: output.gender)
            .disposed(by: disposeBag)
        
        input.studyText
            .orEmpty
            .bind(to: output.study)
            .disposed(by: disposeBag)
        
        input.searchableSwitch
            .bind(to: output.searchable)
            .disposed(by: disposeBag)
        
        input.ageSlider
            .bind(to: output.ageRange)
            .disposed(by: disposeBag)
        
        // 뷰 등장 시 유저 정보 가져오고 스트림 끊기
        input.viewWillAppear
            .flatMap { _ in
                Observable<Void>.create { observer in
                    UserRepository.shared.tryLogin()
                    observer.onError(APIErrors.noResponse)
                    
                    return Disposables.create()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        
        // 저장 버튼 클릭 시 유저 세팅 저장하기 (네트워킹)
        input.saveButtonTap
            .compactMap { _ in
                if let ageRange = output.ageRange.value, let searchable = output.searchable.value, let gender = output.gender.value {
                    
                    return User.UserSetting(
                        study: output.study.value ?? "",
                        searchable: searchable ? 1 : 0,
                        ageMin: Int(ageRange[0]),
                        ageMax: Int(ageRange[1]),
                        gender: gender)
                    
                } else { return nil }
            }
            .bind { UserRepository.shared.tryUpdate(setting: $0) }
            .disposed(by: disposeBag)
            
        
        
        return output
        
    }
    
    
}

extension MyInfoSettingViewModel {
    
    private func createSeSACTitleSection(reputation: [Int]) -> [Reputation] {
        
        let items = reputation.enumerated().compactMap { (index, value) in
            if let title = SeSACTitle(rawValue: index)?.title {
                return ReputationItem(title: title, count: value)
            } else {
                return nil
            }
        }
        
        return [Reputation(items: items)]
        
    }
    
}

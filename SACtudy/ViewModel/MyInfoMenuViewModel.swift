//
//  MyInfoViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/17.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class MyInfoMenuViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        
    }
    
    struct Output {
        let sections = PublishRelay<[Section]>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.viewWillAppear
            .subscribe { _ in
                UserRepository.shared.fetchUserInfo()
            }
            .disposed(by: disposeBag)
        
        let output = Output()
        
        UserRepository.shared.loginResult
            .subscribe { (result: Result<User, APIError>) in
                switch result {
                case .success(let user):
                    let data = [Section(items: [
                        Item(image: .init(name: "sesac_face_\(user.sesac)"), title: user.nick),
                        Item(image: Asset.Images.notice, title: "공지사항"),
                        Item(image: Asset.Images.faq, title: "자주 묻는 질문"),
                        Item(image: Asset.Images.qna, title: "1:1 문의"),
                        Item(image: Asset.Images.settingAlarm, title: "알림 설정"),
                        Item(image: Asset.Images.permit, title: "이용약관")
                    ])]
                    output.sections.accept(data)
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        
        return output

    }
    
}

extension MyInfoMenuViewModel {
    
    struct Item {
        let image: ImageAsset
        let title: String
    }

    struct Section: SectionModelType {
        var items: [Item]
        
        init(items: [Item]){
            self.items = items
        }
        
        init(original: Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
        
}

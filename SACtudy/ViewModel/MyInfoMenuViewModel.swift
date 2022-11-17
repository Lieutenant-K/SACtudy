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
//        let itemSelected: ControlEvent<IndexPath>
//        let modelSelected: ControlEvent<Item>
    }
    
    struct Output {
        let sections: Observable<[Section]>
    }

    
    let sections = [
        Section(items: [Item(image: Asset.Images.profileImg, title: "김새싹"),
                        Item(image: Asset.Images.notice, title: "공지사항"),
                        Item(image: Asset.Images.faq, title: "자주 묻는 질문"),
                        Item(image: Asset.Images.qna, title: "1:1 문의"),
                        Item(image: Asset.Images.settingAlarm, title: "알림 설정"),
                        Item(image: Asset.Images.permit, title: "이용약관")
                       ])
    ]
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        
        return Output(sections: Observable.just(sections))

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

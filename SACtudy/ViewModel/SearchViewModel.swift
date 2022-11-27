//
//  SearchViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewModel: ViewModel, NetworkManager {
    
    let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let viewDidAppear: ControlEvent<Bool>
    }
    
    struct Output {
        let tags = BehaviorRelay<[Section]>(value: [])
        let errorMessage = PublishRelay<String>()
    }
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let fetchNearUser = BehaviorRelay<Coordinate>(value: coordinate)
        
        
        fetchNearUser
            .withUnretained(self)
            .flatMapLatest { model, coordinate in
                model.request(router: .queue(.search(lat: coordinate.latitude, long: coordinate.longitude)), type: UserSearchResult.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(searchResult):
                    if let data = searchResult {
                        output.tags.accept(model.createSections(data: data)) }
                case .error(.tokenError):
                    fetchNearUser.accept(fetchNearUser.value)
                case .error(.network):
                    output.errorMessage.accept(Constant.networkDisconnectMessage)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
       
        
        return output
        
    }
    
}

extension SearchViewModel {
    
    enum Section: AnimatableSectionModelType {
        
        var identity: String {
            switch self {
            case let .around(title, _):
                return title
            case let .prefer(title, _):
                return title
            }
        }
        
        case around(title: String, items: [SectionItem])
        case prefer(title: String, items: [SectionItem])
        
        var items: [SectionItem] {
            switch self {
            case let .around(_, items):
                return items
            case let .prefer(_, items):
                return items
            }
        }
        
        init(original: Section, items: [SectionItem]) {
            
            switch original {
            case let .around(title, _):
                self = .around(title: title, items: items)
            case let .prefer(title, _):
                self = .prefer(title: title, items: items)
            }
            
        }
        
    }
    
    enum SectionItem: IdentifiableType, Hashable {
        
        var identity: String {
            switch self {
            case let .aroundSectionItem(tag, _):
                return tag
            case  let .preferSectionItem(tag):
                return tag
            }
        }
        
        case aroundSectionItem(tag: String, isRecommended: Bool)
        case preferSectionItem(tag: String)
        
    }
    
    func createSections(data: UserSearchResult) -> [Section] {
        
        let recommend = Set<String>(data.fromRecommend)
        
        let study1 = data.fromQueueDB
            .map{ $0.studylist }
            .reduce(Set<String>()) { partialResult, studyList in
                partialResult.union(Set(studyList))
        }
        
        let study2 = data.fromQueueDBRequested
            .map{ $0.studylist }
            .reduce(Set<String>()) { partialResult, studyList in
                partialResult.union(Set(studyList))
        }
        
        let studyList = study1.union(study2).subtracting(recommend)
        
        let aroundItems = recommend.map { SectionItem.aroundSectionItem(tag: $0, isRecommended: true) } + studyList.map { SectionItem.aroundSectionItem(tag: $0, isRecommended: false) }
        
        let aroundSection = Section.around(title: "지금 주변에는", items:aroundItems)
        
        let preferSection = Section.prefer(title: "내가 하고 싶은", items: [SectionItem.preferSectionItem(tag: "내가하고싶은 스터디")])
        
        return [aroundSection, preferSection]
        
    }
    
}

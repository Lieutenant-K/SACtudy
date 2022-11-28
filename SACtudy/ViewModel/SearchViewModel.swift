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
    
    enum SearchError {
        
        case network, overMaxLength, overMaxCount, alreadyExist
        
        var message: String {
            switch self {
            case .network:
                return Constant.networkDisconnectMessage
            case .overMaxCount:
                return "스터디를 더 이상 추가할 수 없습니다"
            case .overMaxLength:
                return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
            case .alreadyExist:
                return "이미 등록된 스터디입니다"
            }
        }
        
    }
    
    let coordinate: Coordinate
    var prefer = Set<String>()
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let modelSelected: ControlEvent<SectionItem>
    }
    
    struct Output {
        let tags = BehaviorRelay<[Section]>(value: [])
        let errorMessage = PublishRelay<SearchError>()
    }
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let fetchNearUser = BehaviorRelay<Coordinate>(value: coordinate)
        let prefer = BehaviorRelay<Set<String>>(value: Set())
        
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
                    output.errorMessage.accept(.network)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.modelSelected
            .bind { item in
                switch item {
                case let .aroundSectionItem(tag, _, _):
                    if prefer.value.contains(tag) {
                        output.errorMessage.accept(.alreadyExist) }
                    else if prefer.value.count < 8 {
                        prefer.accept(prefer.value.union([tag])) }
                    else {
                        output.errorMessage.accept(.overMaxCount) }
                case let .preferSectionItem(tag, _):
                    prefer.accept(prefer.value.subtracting([tag]))
                }
            }
            .disposed(by: disposeBag)
        
        prefer
            .map{ $0.map { SectionItem.preferSectionItem(tag: $0, id: UUID()) } }
            .map { item in
                output.tags.value.map { section in
                    switch section {
                    case .around:
                        return section
                    case let .prefer(title, _):
                        return Section.prefer(title: title, items: item)
                    }
                }
            }
            .bind(to: output.tags)
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
        
        var identity: UUID {
            switch self {
            case let .aroundSectionItem(_, _, id):
                return id
            case  let .preferSectionItem(_, id):
                return id
            }
        }
        
        case aroundSectionItem(tag: String, isRecommended: Bool, id: UUID)
        case preferSectionItem(tag: String, id: UUID)
        
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
        
        let aroundItems = recommend.map { SectionItem.aroundSectionItem(tag: $0, isRecommended: true, id: UUID()) } + studyList.map { SectionItem.aroundSectionItem(tag: $0, isRecommended: false, id: UUID()) }
        
        let aroundSection = Section.around(title: "지금 주변에는", items:aroundItems)
        
        let preferSection = Section.prefer(title: "내가 하고 싶은", items: [])
        
        return [aroundSection, preferSection]
        
    }
    
}

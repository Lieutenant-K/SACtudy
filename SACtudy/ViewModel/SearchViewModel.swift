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
    
    enum SearchError: Int, Error {
        
//        case success = 200
        case reportedUser = 201
        case cancelPenalty1 = 203
        case cancelPenalty2 = 204
        case cancelPenalty3 = 205
        case network
        case overMaxLength
        case overMaxCount
        case alreadyExist
        
        var message: String? {
            switch self {
//            case .success:
//                return nil
            case .network:
                return Constant.networkDisconnectMessage
            case .overMaxCount:
                return "스터디를 더 이상 추가할 수 없습니다"
            case .overMaxLength:
                return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
            case .alreadyExist:
                return "이미 등록된 스터디입니다"
            case .reportedUser:
                return "신고가 누적되어 이용하실 수 없습니다"
            case .cancelPenalty1:
                return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
            case .cancelPenalty2:
                return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
            case .cancelPenalty3:
                return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
            }
        }
    }

    
    let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let modelSelected: ControlEvent<SectionItem>
        let searchResult: ControlEvent<String?>
    }
    
    struct Output {
        let tags = BehaviorRelay<[Section]>(value: [])
        let result = PublishRelay<Result<Coordinate, SearchError>>()
    }
    
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        let fetchNearUser = BehaviorRelay<Coordinate>(value: coordinate)
        let searchStudy = BehaviorRelay<StudyRequestModel?>(value: nil)
        let prefer = BehaviorRelay<Set<String>>(value: Set())
        
        fetchNearUser
            .withUnretained(self)
            .flatMapLatest { model, coordinate in
                model.request(router: .queue(.searchNearStudy(coordinate: coordinate)), type: UserSearchResult.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(searchResult):
                    if let data = searchResult {
                        output.tags.accept(model.createSections(data: data)) }
                case .error(.tokenError):
                    fetchNearUser.accept(fetchNearUser.value)
                case .error(.network):
                    output.result.accept(.failure(.network))
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        searchStudy
            .compactMap{$0}
            .withUnretained(self)
            .flatMapLatest { model, data in
                model.request(router: .queue(.requestMyStudy(data: data)), type: Empty.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case .success:
                    output.result.accept(.success(model.coordinate))
                case .error(.tokenError):
                    searchStudy.accept(searchStudy.value)
                case .error(.network):
                    output.result.accept(.failure(.network))
                case let .status(code):
                    if let error = SearchError(rawValue: code) {
                        output.result.accept(.failure(error)) }
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .withUnretained(self)
            .map { model, _ in
                let list = prefer.value.map{$0}
                return StudyRequestModel(
                    coordinate: model.coordinate,
                    studyList: list.isEmpty ? ["anything"] : list
                )}
            .bind(to: searchStudy)
            .disposed(by: disposeBag)
        
        input.searchResult
            .compactMap { $0 }
            .map { Set($0.split(separator: " ").map{ String($0) }) }
            .bind { strings in
                for str in strings {
                    if prefer.value.contains(str) {
                        output.result.accept(.failure(.alreadyExist))
                        return
                    } else if prefer.value.count + strings.count > 8 {
                        output.result.accept(.failure(.overMaxCount))
                        return
                    } else if str.count < 1 || str.count > 8 {
                        output.result.accept(.failure(.overMaxLength))
                        return
                    }
                }
                prefer.accept(prefer.value.union(strings))
            }
            .disposed(by: disposeBag)
        
        
        input.modelSelected
            .bind { item in
                switch item {
                case let .aroundSectionItem(tag, _, _):
                    if prefer.value.contains(tag) {
                        output.result.accept(.failure(.alreadyExist)) }
                    else if prefer.value.count < 8 {
                        prefer.accept(prefer.value.union([tag])) }
                    else {
                        output.result.accept(.failure(.overMaxCount)) }
                case let .preferSectionItem(tag, _):
                    prefer.accept(prefer.value.subtracting([tag]))
                }
            }
            .disposed(by: disposeBag)
        
        prefer
            .map { item in
                let preferItems = item.map { SectionItem.preferSectionItem(tag: $0, id: UUID()) }
                return output.tags.value.map { section in
                    switch section {
                    case .around:
                        return section
                    case let .prefer(title, _):
                        return Section.prefer(title: title, items: preferItems)
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

//
//  WriteReviewViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import Foundation
import RxSwift
import RxCocoa

class WriteReviewViewModel: ViewModel, NetworkManager {
    let uid: String
    var reputation = [Int].init(repeating: 0, count: SeSACTitle.allCases.count)
    
    init(uid: String) {
        self.uid = uid
    }
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let comment: ControlProperty<String?>
        let registerButtonTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let buttonActive = BehaviorRelay<Bool>(value: false)
        let reputation = PublishRelay<[Reputation]>()
        let writeResult = PublishRelay<WriteResult>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let writeReview = BehaviorRelay<WriteReviewModel?>(value: nil)
        let sesacTitle = PublishRelay<[Int]>()
        
        writeReview
            .compactMap{$0}
            .withUnretained(self)
            .flatMapLatest { model, data in
                model.request(router: .queue(.writeReview(data: data)), type: Empty.self)
            }
            .subscribe{ result in
                switch result {
                case .success:
                    output.writeResult.accept(.success)
                case .error(.tokenError):
                    writeReview.accept(writeReview.value)
                case .error(.network):
                    output.writeResult.accept(.networkError)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        sesacTitle
            .compactMap{ value in
                let items = value.enumerated().compactMap { (index, value) in
                    if let title = SeSACTitle(rawValue: index)?.title {
                        return ReputationItem(title: title, count: value)
                    }
                    return nil
                }
                return [Reputation(items: items)]
            }
            .bind(to: output.reputation)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .map { model, _ in model.reputation }
            .bind(to: sesacTitle)
            .disposed(by: disposeBag)
        
        input.comment
            .orEmpty
            .map { $0.count > 500 ?
                $0.substring(from: 0, to: 500) : $0
            }
            .bind(to: input.comment)
            .disposed(by: disposeBag)
        
        input.comment
            .orEmpty
            .withUnretained(self)
            .map { model, text in
                text.count > 0 && text.count <= 500 }
            .bind(to: output.buttonActive)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withUnretained(self)
            .map { model, indexPath in
                let isActive = model.reputation[indexPath.item]
                model.reputation[indexPath.item] = isActive == 1 ? 0 : 1
                return model.reputation
            }
            .bind(to: sesacTitle)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withUnretained(self)
            .map { model, _ in model.reputation.contains(1)}
            .bind(to: output.buttonActive)
            .disposed(by: disposeBag)
        
        input.registerButtonTap
            .withLatestFrom(input.comment.asObservable())
            .withUnretained(self)
            .map { (model, comment) in
                WriteReviewModel(uid: model.uid, reputation: model.reputation + [0,0,0], comment: comment ?? "")
            }
            .bind(to: writeReview)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension WriteReviewViewModel {
    enum WriteResult {
        case success, networkError
    }
}

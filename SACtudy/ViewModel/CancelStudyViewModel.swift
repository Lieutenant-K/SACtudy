//
//  CancelStudyViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import Foundation
import RxSwift
import RxCocoa

class CancelStudyViewModel: ViewModel, NetworkManager {
    let uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    struct Input {
        let okButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let cancelResult = PublishRelay<CancelResult>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let cancelStudy = PublishRelay<String>()
        
        cancelStudy
            .withUnretained(self)
            .flatMapLatest { model, uid in
                model.request(router: .queue(.cancelStudy(uid: uid)), type: Empty.self)
            }
            .subscribe(with: self) { model, result in
                switch result {
                case .success:
                    output.cancelResult.accept(.success)
                case .error(.tokenError):
                    cancelStudy.accept(model.uid)
                case .error(.network):
                    output.cancelResult.accept(.networkError)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        input.okButtonTap
            .withUnretained(self)
            .map { model, _ in model.uid }
            .bind(to: cancelStudy)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension CancelStudyViewModel {
    enum CancelResult {
        case success, networkError
    }
}

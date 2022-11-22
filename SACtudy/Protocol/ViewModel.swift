//
//  ViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/22.
//

import Foundation
import RxSwift

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
    
}

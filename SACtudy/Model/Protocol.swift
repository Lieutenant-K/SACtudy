//
//  Protocol.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import Foundation
import RxSwift

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
    
}

protocol ViewController {
    
    var viewModel: any ViewModel { get }
    
    func binding()
    
}

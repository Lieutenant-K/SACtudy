//
//  AuthViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa

class AuthViewModel {
    
    let phoneNumber = PublishRelay<String>()
    
    let validation = BehaviorRelay<Bool>(value: false)
    
    func inputText(text: String) {
        
        var ranges: [(Int, Int)] = []
        let str = text.filter { $0.isNumber }
        
        let count = str.count
        if count <= 3 {
            ranges = [(0,count)]
        } else if count < 7 {
            ranges = [ (0, 3), (3, count) ]
        } else if count < 11 {
            ranges = [ (0, 3), (3, 6), (6, count) ]
        } else {
            ranges = [ (0, 3), (3, 7), (7, 11) ]
        }
        
        let number = ranges
            .map { str.substring(from: $0.0, to: $0.1) }
            .joined(separator: "-")
        
        phoneNumber.accept(number)
        
        checkValidation(text: text)
    
        
    }
    
    @discardableResult
    func checkValidation(text: String) -> Bool {
        
        let text = text.filter { $0.isNumber }
        
        let valid = (text[0] == "0" && text[1] == "1" && text.count >= 10)
        
        validation.accept(valid)
        
        return valid
        
    }
    
}


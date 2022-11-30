//
//  Reputation.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import Foundation
import RxDataSources
import RxSwift

struct ReputationItem {
    
    let title: String
    let count: Int
    
}

struct Reputation: SectionModelType {
    
    var items: [ReputationItem]
    
    init(items: [ReputationItem]) {
        self.items = items
    }
    
    init(original: Reputation, items: [ReputationItem]) {
        self = original
        self.items = items
    }
    
}

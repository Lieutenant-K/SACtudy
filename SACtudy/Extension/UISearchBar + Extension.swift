//
//  UISearchBar + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    
    var searchResult: ControlEvent<String?> {
        ControlEvent(events: searchButtonClicked.map { base.text })
    }
    
}

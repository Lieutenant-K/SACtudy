//
//  UICollectionViewCell + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
}

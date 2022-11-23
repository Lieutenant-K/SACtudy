//
//  UIBarButtonItem + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/24.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(text: String, font: FontSet) {
        self.init(title: text, style: .plain, target: nil, action: nil)
        
        let attr: [NSAttributedString.Key:Any] = [
            .font:font.font,
            .baselineOffset:font.baselineOffset,
            .paragraphStyle:font.paragraph
        ]
        
        setTitleTextAttributes(attr, for: .normal)
    }
    
}

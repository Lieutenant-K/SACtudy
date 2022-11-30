//
//  NSAttributedString + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/10.
//

import UIKit

extension NSAttributedString {
    
    convenience init(text: String, font: FontSet, color: UIColor) {
        let attr: [NSAttributedString.Key:Any] = [
            .font:font.font, .baselineOffset:font.baselineOffset, .paragraphStyle:font.paragraph, .foregroundColor:color
        ]
        self.init(string: text, attributes: attr)
    }
}

extension AttributedString {
    
    init(text: String, font: FontSet, color: UIColor) {
        self.init(NSAttributedString(text: text, font: font, color: color))
    }
    
}

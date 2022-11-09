//
//  UILabel + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension UILabel {
    
    func applyAppearnce(text: String, font: FontSet, color: UIColor) {
        
        var attr = AttributedString(stringLiteral: text)
        attr.applyFontSet(font)
        attr.foregroundColor = color

        attributedText = NSAttributedString(attr)
        
    }
    
    func changeAttributes(string: String, font: UIFont, color: UIColor) {
        
        guard let text else { return }
        
        let range = NSString(string: text).range(of: string)
        
        let mutableAttr = NSMutableAttributedString()
        
        if let attr = attributedText {
            mutableAttr.setAttributedString(attr)
        } else {
            mutableAttr.setAttributedString(NSAttributedString(string: text))
        }

        mutableAttr.setAttributes([.font: font, .foregroundColor: color], range: range)
        
        attributedText = mutableAttr
        
    }
    
    convenience init(text: String = " ", font: FontSet, color: UIColor = Asset.Colors.black.color) {
        self.init()
        applyAppearnce(text: text, font: font, color: color)
//        self.text = text
        
    }
    
    
}

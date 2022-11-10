//
//  UILabel + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension UILabel {
    
    func changeAttributes(string: String, font: UIFont, color: UIColor) {
        
        guard let text else { return }
        
        let range = NSString(string: text).range(of: string)
        
        let mutableAttr = NSMutableAttributedString(string: text)
        
        if let attr = attributedText {
            mutableAttr.setAttributedString(attr)
        }

        mutableAttr.addAttributes([.font: font, .foregroundColor: color], range: range)
        
        attributedText = mutableAttr
        
    }
    
    convenience init(text: String, font: FontSet, color: UIColor = Asset.Colors.black.color) {
        self.init()
        attributedText = NSAttributedString(text: text, font: font, color: color)
        
    }
    
    
}

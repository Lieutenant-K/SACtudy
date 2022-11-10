//
//  UIFont + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension UIFont {
    
    func createFontSet(ratio: CGFloat) -> FontSet {
        
        let fontSize = self.pointSize
        let style = NSMutableParagraphStyle()
        
        let lineHeight = fontSize * ratio
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        style.alignment = .center
        style.lineBreakMode = .byCharWrapping
        
        return FontSet(font: self, paragraph: style, baselineOffset: (lineHeight - self.lineHeight) / 2)
    }
    
}

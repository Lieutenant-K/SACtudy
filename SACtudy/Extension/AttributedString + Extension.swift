//
//  AttributedString + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension AttributedString {
    
    mutating func applyFontSet(_ fontSet: FontSet) {
        
        self.font = fontSet.font
        self.baselineOffset = fontSet.baselineOffset
        self.paragraphStyle = fontSet.paragraph
        
    }
    
}

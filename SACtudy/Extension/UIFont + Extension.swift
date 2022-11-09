//
//  UIFont + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

struct FontSet {
    
    let font: UIFont
    let paragraph: NSParagraphStyle
    let baselineOffset: CGFloat
    
}

extension FontSet {
    
    static var display: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 20).createFontSet(ratio: 1.6)
    }
    
    static var title1: FontSet {
        FontFamily.NotoSansKR.medium.font(size: 16).createFontSet(ratio: 1.6)
    }
    
    static var title2: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 16).createFontSet(ratio: 1.6)
    }
    
    static var title3: FontSet {
        FontFamily.NotoSansKR.medium.font(size: 14).createFontSet(ratio: 1.6)
    }
    
    static var title4: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 16).createFontSet(ratio: 1.6)
    }
    
    static var title5: FontSet {
        FontFamily.NotoSansKR.medium.font(size: 12).createFontSet(ratio: 1.5)
    }
    
    static var title6: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 12).createFontSet(ratio: 1.5)
    }
    
    static var body1: FontSet {
        FontFamily.NotoSansKR.medium.font(size: 16).createFontSet(ratio: 1.85)
    }
    
    static var body2: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 16).createFontSet(ratio: 1.85)
    }
    
    static var body3: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 14).createFontSet(ratio: 1.7)
    }
    
    static var body4: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 12).createFontSet(ratio: 1.8)
    }
    
    static var caption: FontSet {
        FontFamily.NotoSansKR.regular.font(size: 10).createFontSet(ratio: 1.6)
    }
    
    
}

extension UIFont {
    
    func createFontSet(ratio: CGFloat) -> FontSet {
        
        let fontSize = self.pointSize
        let style = NSMutableParagraphStyle()
        
        let lineHeight = fontSize * ratio
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        return FontSet(font: self, paragraph: style, baselineOffset: (lineHeight - fontSize) / 4)
    }
    
}

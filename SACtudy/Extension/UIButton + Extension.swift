//
//  Extension + UIButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

extension UIButton {
    
    struct ColorSet {
    
        let titleColor: UIColor
        let backgroundColor: UIColor
        let strokeColor: UIColor
        let imageColor: UIColor
        
    }
    
    func configureAppearance(color: ColorSet? = nil, font: FontSet? = nil) {
        
        if let color {
            configuration?.applyColorSet(color)
        }
        if let font {
            configuration?.attributedTitle?.applyFontSet(font)
        }
        
    }
    
}

extension UIButton.Configuration {
    
    mutating func applyColorSet(_ colorSet: UIButton.ColorSet) {
        
        background.backgroundColor = colorSet.backgroundColor
        background.strokeColor = colorSet.strokeColor
        imageColorTransformer = .init { _ in
            return colorSet.imageColor
        }
        attributedTitle?.foregroundColor = colorSet.titleColor
        
    }
    
    
}

extension UIButton.ColorSet {
    
    static var fill: UIButton.ColorSet {
        UIButton.ColorSet(
            titleColor: Asset.Colors.white.color,
            backgroundColor: Asset.Colors.green.color,
            strokeColor: Asset.Colors.green.color,
            imageColor: Asset.Colors.black.color
        )
    }
    
    static var inactive: UIButton.ColorSet {
        UIButton.ColorSet(
            titleColor: Asset.Colors.black.color,
            backgroundColor: Asset.Colors.white.color,
            strokeColor: Asset.Colors.gray4.color,
            imageColor: Asset.Colors.black.color)
    }
    
    static var outline: UIButton.ColorSet {
        UIButton.ColorSet(
            titleColor: Asset.Colors.green.color,
            backgroundColor: Asset.Colors.white.color,
            strokeColor: Asset.Colors.green.color,
            imageColor: Asset.Colors.green.color)
    }
    
    static var cancel: UIButton.ColorSet {
        UIButton.ColorSet(
            titleColor: Asset.Colors.black.color,
            backgroundColor: Asset.Colors.gray2.color,
            strokeColor: Asset.Colors.gray2.color,
            imageColor: Asset.Colors.black.color)
    }
    
    static var disable: UIButton.ColorSet {
        UIButton.ColorSet(
            titleColor: Asset.Colors.gray3.color,
            backgroundColor: Asset.Colors.gray6.color,
            strokeColor: Asset.Colors.gray6.color,
            imageColor: Asset.Colors.gray3.color)
    }
    
}

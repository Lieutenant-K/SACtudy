//
//  ColorSet.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/10.
//

import UIKit

struct ColorSet {

    let titleColor: UIColor
    let backgroundColor: UIColor
    let strokeColor: UIColor
    let imageColor: UIColor
    
}

extension ColorSet {
    
    static var fill: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.white.color,
            backgroundColor: Asset.Colors.green.color,
            strokeColor: Asset.Colors.green.color,
            imageColor: Asset.Colors.black.color
        )
    }
    
    static var normal: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.black.color,
            backgroundColor: Asset.Colors.white.color,
            strokeColor: Asset.Colors.white.color,
            imageColor: Asset.Colors.black.color
        )
    }
    
    static var inactive: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.black.color,
            backgroundColor: Asset.Colors.white.color,
            strokeColor: Asset.Colors.gray4.color,
            imageColor: Asset.Colors.black.color)
    }
    
    static var outline: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.green.color,
            backgroundColor: Asset.Colors.white.color,
            strokeColor: Asset.Colors.green.color,
            imageColor: Asset.Colors.green.color)
    }
    
    static var cancel: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.black.color,
            backgroundColor: Asset.Colors.gray2.color,
            strokeColor: Asset.Colors.gray2.color,
            imageColor: Asset.Colors.black.color)
    }
    
    static var disable: ColorSet {
        ColorSet(
            titleColor: Asset.Colors.gray3.color,
            backgroundColor: Asset.Colors.gray6.color,
            strokeColor: Asset.Colors.gray6.color,
            imageColor: Asset.Colors.gray3.color)
    }
    
}

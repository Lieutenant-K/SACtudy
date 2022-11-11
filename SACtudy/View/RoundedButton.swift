//
//  RoundedButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit
import SnapKit

class RoundedButton: UIButton {
    
    var image: UIImage? {
        get { return configuration?.image }
        set { configuration?.image = newValue }
    }
    
    func configureButton(text: String, font: FontSet, color: ColorSet) {
        
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .fixed
        config.background.cornerRadius = 8
        config.background.strokeWidth = 1
        config.titleAlignment = .center
        config.background.backgroundColor = color.backgroundColor
        config.background.strokeColor = color.strokeColor
        config.imageColorTransformer = UIConfigurationColorTransformer({ _ in
            return color.imageColor
        })
        
        config.attributedTitle =
        AttributedString(NSAttributedString(text: text, font: font, color: color.titleColor))
        
        configuration = config
    }
    
    func changeColor(color: ColorSet) {
        
        guard var config = configuration else { return }
        
        config.background.backgroundColor = color.backgroundColor
        config.background.strokeColor = color.strokeColor
        config.imageColorTransformer = UIConfigurationColorTransformer({ _ in
            return color.imageColor
        })
        config.attributedTitle?.foregroundColor = color.titleColor
        
        configuration = config
    }
    
    init(title: String = "", image: UIImage? = nil, fontSet: FontSet, colorSet: ColorSet, height: Height) {
        super.init(frame: .zero)
        configureButton(text: title, font: fontSet, color: colorSet)
        setHeightConstraint(height: height.value)
        self.image = image
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoundedButton {
    
    enum Height {
        
        case h48, h40, h32
        
        var value: Int {
            switch self {
            case .h32:
                return 32
            case .h40:
                return 40
            case .h48:
                return 48
            }
        }
        
    }
    
    func setHeightConstraint(height: Int) {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
    }
    
    
}

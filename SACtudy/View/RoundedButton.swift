//
//  RoundedButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit
import SnapKit

class RoundedButton: UIButton {
    
    var title: String? {
        get { return super.currentTitle }
        set { configuration?.title = newValue }
    }
    
    var image: UIImage? {
        get { return configuration?.image }
        set { configuration?.image = newValue }
    }
    
    func configureButton() {
        
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .fixed
        config.background.cornerRadius = 8
        config.background.strokeWidth = 1
        config.attributedTitle = AttributedString()
        config.titleAlignment = .center
        
        configuration = config
    }
    
    convenience init(title: String = "타이틀", image: UIImage? = nil, fontSet: FontSet, colorSet: ColorSet, height: Height) {
        self.init()
        self.title = title
        self.image = image
        configureAppearance(color: colorSet, font: fontSet)
        setHeightConstraint(height: height.value)
        
    }
    
    init() {
        super.init(frame: .zero)
        configureButton()
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

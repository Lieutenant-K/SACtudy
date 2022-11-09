//
//  RoundedButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit

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
    
    convenience init(title: String = "타이틀", image: UIImage? = nil, fontSet: FontSet, colorSet: ColorSet) {
        self.init()
        self.title = title
        self.image = image
        configuration?.applyColorSet(colorSet)
        configuration?.attributedTitle?.applyFontSet(fontSet)
        
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

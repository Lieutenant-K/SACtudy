//
//  TitleStackView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class TitleStackView<T: UIView> : UIStackView {

    let titleLabel: UILabel
    
    let view: T
    
    func configureStackView() {
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(view)
        
        axis = .vertical
        spacing = 16
        distribution = .fill
        alignment = .fill
        
        titleLabel.textAlignment = .left
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        
    }
    
    init(title: String, view: T) {
        self.view = view
        self.titleLabel = UILabel(text: title, font: .title6)
        super.init(frame: .zero)
        configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

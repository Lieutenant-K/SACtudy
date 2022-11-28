//
//  RoundedButtonCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class RoundedButtonCell: UICollectionViewCell {
    
    let button = RoundedButton(title: "기본 버튼",fontSet: .title4, colorSet: .inactive, height: .h32)
    
    private func configureButton() {
        
        contentView.addSubview(button)
        button.isUserInteractionEnabled = false
        button.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

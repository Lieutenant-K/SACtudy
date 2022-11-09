//
//  OnboardingCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit
import SnapKit
import Then

class OnboardingCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel(font: FontFamily.NotoSansKR.regular.font(size: 24).createFontSet(ratio: 1.6)).then {
        
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    func configureCell() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(imageView.snp.top).offset(0)
        }
        
        
    }
    
    func inputData(data: OnboardViewController.OnboardItem) {
        
        titleLabel.text = data.title
        imageView.image = data.image
        
        if let string = data.highlightString {
            
            let font = FontFamily.NotoSansKR.medium.font(size: 24)
            let color = Asset.Colors.green.color
            
            titleLabel.changeAttributes(string: string, font: font, color: color)
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

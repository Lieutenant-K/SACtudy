//
//  MyInfoCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/17.
//

import UIKit
import SnapKit

class MyInfoCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: Asset.Images.man.image)
    let titleLabel = UILabel(text: "예시입니다", font: .title2)
    let accessory = UIImageView(image: Asset.Images.moreArrow.image)
    
    func inputData(title: String, image: UIImage, isFirst: Bool) {
        
        imageView.image = image
        titleLabel.attributedText = NSAttributedString(text: title, font: isFirst ? .title1 : .title2, color: .black)
        accessory.isHidden = !isFirst
        
        if isFirst {
            imageView.snp.updateConstraints { $0.size.equalTo(50) }
        }
        
    }
    
    private func configureCell() {
        
        [imageView, titleLabel, accessory].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.leading.equalToSuperview().inset(17)
            make.verticalEdges.equalToSuperview().inset(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(13)
        }
        
        accessory.isHidden = true
        accessory.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.trailing.equalToSuperview().inset(17)
            make.size.equalTo(25)
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

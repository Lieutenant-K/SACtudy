//
//  ChatCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import SnapKit

class ChatCell: UICollectionViewCell, ChatCellType {
    let content: RoundedButton
    let timeLabel: UILabel
    
    func constraintSubview() {
        [content, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        content.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(content.snp.trailing).offset(8)
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    func inputData(data: ChatData) {
        timeLabel.attributedText = NSAttributedString(text: data.createdAt, font: .title6, color: Asset.Colors.gray6.color)
        timeLabel.textAlignment = .left
        content.configureButton(text: data.content, font: .body3, color: .inactive)
        content.titleLabel?.numberOfLines = 0
        content.contentHorizontalAlignment = .left
    }
    
    override init(frame: CGRect) {
        content = RoundedButton(fontSet: .body3, colorSet: .inactive)
        timeLabel = UILabel(text: "00:00", font: .title6, color: Asset.Colors.gray6.color)
        super.init(frame: frame)
        constraintSubview()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

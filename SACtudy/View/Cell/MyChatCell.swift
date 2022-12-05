//
//  MyChatCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import SnapKit

class MyChatCell: UICollectionViewCell, ChatCellType {
    let content: RoundedButton
    let timeLabel: UILabel
    
    func constraintSubview() {
        [content, timeLabel].forEach {
            contentView.addSubview($0)
        }
        
        content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        content.setContentHuggingPriority(.defaultLow, for: .horizontal)
        content.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview()
        }
        
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(content.snp.leading).offset(-8)
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(40)
        }
    }
    
    func inputData(data: ChatData) {
        timeLabel.attributedText = NSAttributedString(text: data.createdAt, font: .title6, color: Asset.Colors.gray6.color)
        timeLabel.textAlignment = .left
        
        let colorSet = ColorSet(titleColor: Asset.Colors.black.color,
                                backgroundColor: Asset.Colors.whitegreen.color,
                                strokeColor: Asset.Colors.whitegreen.color,
                                imageColor: Asset.Colors.black.color)
        let fontSet = FontSet.body3
        let paragraph = fontSet.paragraph as? NSMutableParagraphStyle
        paragraph?.alignment = .left
        let newFontSet = FontSet(font: fontSet.font, paragraph: paragraph ?? fontSet.paragraph, baselineOffset: fontSet.baselineOffset)
        
        content.configureButton(text: data.content, font: newFontSet, color: colorSet)
        content.titleLabel?.numberOfLines = 0

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

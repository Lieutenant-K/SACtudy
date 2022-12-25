//
//  ChattingAnnounceHeaderView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/05.
//

import UIKit
import SnapKit

final class ChattingAnnounceHeaderView: UICollectionReusableView {
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    
    private func constraintSubviews(){
        [titleLabel, subtitleLabel].forEach{addSubview($0)}
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(snp.centerY).offset(-2)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
        subtitleLabel.snp.makeConstraints{
            $0.top.equalTo(snp.centerY).offset(2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func inputData(nick: String) {
        let attach = NSTextAttachment()
        attach.image = Asset.Images.bell.image
        
        let attr = NSMutableAttributedString(attachment: attach)
        let title = NSAttributedString(text: "\(nick)님과 매칭되었습니다", font: .title3, color: Asset.Colors.gray7.color)
        let subtitle = NSAttributedString(text: "채팅을 통해 약속을 정해보세요 :)", font: .title4, color: Asset.Colors.gray6.color)
        
        attr.append(title)
        titleLabel.attributedText = attr
        subtitleLabel.attributedText = subtitle
    }
    
    override init(frame: CGRect) {
        titleLabel = UILabel(text: "타이틀", font: .title3, color: Asset.Colors.gray7.color)
        subtitleLabel = UILabel(text: "서브 타이틀", font: .title4, color: Asset.Colors.gray6.color)
        super.init(frame: frame)
        constraintSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

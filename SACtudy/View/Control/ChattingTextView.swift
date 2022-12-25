//
//  ChattingTextView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChattingTextView: RoundedTextView {
    
    let sendButton = UIButton()
    
    override var inset: UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 10 + 12 + sendButton.frame.size.width)
    }
    
    override var contentSize: CGSize {
        didSet {
            if numberOfLines <= 3 {
                heightConstraint?.update(offset: contentSize.height)
            }
        }
    }
    
    override func configureTextView(placeholder: String) {
        super.configureTextView(placeholder: placeholder)
        
        // 채팅보내기 버튼 설정
        addSubview(sendButton)
        sendButton.setImage(Asset.Images.sendActive.image, for: .normal)
        sendButton.setImage(Asset.Images.sendInactive.image, for: .disabled)
        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(frameLayoutGuide)
            $0.trailing.equalTo(frameLayoutGuide).inset(inset.left)
        }
        
        // 버튼 비활성화 기능
        self.rx.text
            .orEmpty
            .withUnretained(self)
            .map{ view, text in
                view.textColor != view.placeholderColor && text.count > 0
            }
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = inset
    }
    
}

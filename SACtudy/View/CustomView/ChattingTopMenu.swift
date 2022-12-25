//
//  ChattingTopMenu.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/05.
//

import UIKit
import RxSwift

final class ChattingTopMenu: UIStackView {
    let reportButton = UIButton(type: .system)
    let cancelStudyButton = UIButton(type: .system)
    let registerReviewButton = UIButton(type: .system)
    let bottomInsetView = UIView()
    let buttonStack: UIStackView
    
    private func configureSubviews() {
        let image = Asset.Images.self
        let color = Asset.Colors.self
        
        let title = ["새싹 신고", "스터디 취소", "리뷰 등록"]
        let icon = [image.siren, image.cancelMatch, image.write]
        [reportButton, cancelStudyButton, registerReviewButton].enumerated().forEach { (index, button) in
            var config = UIButton.Configuration.plain()
            config.image = icon[index].image
            config.imagePlacement = .top
            config.imagePadding = 4
            config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0)
            config.attributedTitle = AttributedString(text: title[index], font: .title3, color: color.black.color)
            
            button.configuration = config
        }
        
        bottomInsetView.backgroundColor = color.black.color.withAlphaComponent(0.5)
        bottomInsetView.addGestureRecognizer(UITapGestureRecognizer())
    }
    
    init(){
        self.buttonStack = UIStackView(arrangedSubviews: [reportButton, cancelStudyButton, registerReviewButton])
        buttonStack.distribution = .fillEqually
        buttonStack.axis = .horizontal
        buttonStack.backgroundColor = Asset.Colors.white.color
        buttonStack.isHidden = true
        super.init(frame: .zero)
        addArrangedSubview(buttonStack)
        addArrangedSubview(bottomInsetView)
        axis = .vertical
        configureSubviews()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: ChattingTopMenu {
    var isRevealed: Binder<Bool> {
        Binder(base) { base, bool in
            let isHidden = !bool
            let alpha = bool ? 1.0 : 0.0
            if bool {
                base.isHidden = isHidden
                UIView.animate(withDuration: 0.3) {
                    base.alpha = alpha
                    base.buttonStack.isHidden = isHidden
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    base.alpha = alpha
                    base.buttonStack.isHidden = isHidden
                } completion: { bool in
                    base.isHidden = isHidden
                }
            }
        }
    }
}

//
//  WriteReviewView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import SnapKit

class WriteReviewView: UIView {
    let titleCollection: SeSACTitleCollectionView
    let reviewTextView: RoundedTextView
    let registerButton: RoundedButton
    let cancelButton: UIButton
    private let titleLabel: UILabel
    private let subtitleLabel: UILabel
    private let containerView: UIView
    
    init(nickname: String) {
        self.titleCollection = SeSACTitleCollectionView()
        self.reviewTextView = RoundedTextView(placeholder: "자세한 피드백은 다른 새싹들에게도 도움이 됩니다\n(500자 이내 작성)")
        self.registerButton = RoundedButton(title: "리뷰 등록하기", fontSet: .body3, colorSet: .disable, height: .h48)
        self.titleLabel = UILabel(text: "리뷰 등록", font: .title3)
        self.subtitleLabel = UILabel(text: "\(nickname)님과의 스터디는 어떠셨나요?", font: .title4, color: Asset.Colors.green.color)
        self.cancelButton = UIButton(type: .system)
        self.containerView = UIView()
        super.init(frame: .zero)
        constraintSubviews()
        configureSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraintSubviews() {
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 16
        labelStack.alignment = .center
        
        reviewTextView.snp.makeConstraints {
            $0.height.equalTo(125)
        }
        
        let verticalStack = UIStackView(arrangedSubviews: [labelStack, titleCollection, reviewTextView, registerButton])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.spacing = 24
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(0)
        }
        
        containerView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }
    }
    
    private func configureSubviews() {
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        
        cancelButton.setImage(Asset.Images.closeBig.image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    

}

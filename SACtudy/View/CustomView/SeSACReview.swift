//
//  SeSACReview.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

class SeSACReview: UIView {

    let moreButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(Asset.Images.moreArrow.image, for: .normal)
    }
    
    let reviewLabel: UILabel
    
    private let titleLabel: UILabel
    
    private let stackView = TitleStackView(title: "새싹 리뷰", view: UILabel(text: "첫 리뷰를 기다리는 중이에요!", font: .body3, color: Asset.Colors.gray6.color))
    
    private func configureView() {
        
        [stackView, moreButton].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(16)
            make.trailing.equalToSuperview()
        }

        reviewLabel.textAlignment = .left
        reviewLabel.numberOfLines = 0
        
    }
    
    init() {
        reviewLabel = stackView.view
        titleLabel = stackView.titleLabel
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

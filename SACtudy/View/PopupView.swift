//
//  PopupView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class PopupView: UIView {
    
    let cancleButton = RoundedButton(title: "취소", fontSet: .body3, colorSet: .cancel, height: .h48)
    
    let okButton = RoundedButton(title: "확인", fontSet: .body3, colorSet: .fill, height: .h48)
    
    let titleLabel: UILabel
    let subtitleLabel: UILabel
    
    private func configureView() {
        
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
        
        let buttonStack = UIStackView(arrangedSubviews: [cancleButton, okButton]).then {
            $0.spacing = 8
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel]).then {
            $0.spacing = 8
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        let verticalStack = UIStackView(arrangedSubviews: [labelStack, buttonStack]).then {
            $0.spacing = 16
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        let container = UIView().then {
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.addSubview(verticalStack)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    init(title: String, subtitle: String) {
        titleLabel = UILabel(text: title, font: .body1)
        subtitleLabel = UILabel(text: subtitle, font: .title4)
        super.init(frame: .zero)
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

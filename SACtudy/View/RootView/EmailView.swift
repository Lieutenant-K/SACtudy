//
//  EmailView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class EmailView: UIView {

    let nextButton = RoundedButton(title: "다음", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let inputTextField = LineTextField(placeholder: "SeSAC@email.com", font: .title4)
    
    let titleLabel = UILabel(text: "이메일을 입력해 주세요", font: .display)
    let subtitleLabel = UILabel(text: "휴대폰 번호 변경 시 인증을 위해 사용해요", font: .title2, color: Asset.Colors.gray7.color)
 
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, subtitleLabel, inputTextField, nextButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        
        inputTextField.keyboardType = .emailAddress
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
//            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
            make.height.equalTo(48)
        }
        

        nextButton.snp.makeConstraints { make in
//            make.top.equalTo(inputTextField.snp.bottom).offset(72)
            make.bottom.equalToSuperview().offset(-height*0.43)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

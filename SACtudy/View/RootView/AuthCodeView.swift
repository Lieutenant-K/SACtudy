//
//  AuthCodeView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class AuthCodeView: UIView {

    let authButton = RoundedButton(title: "인증하고 시작하기", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let codeTextField = LineTextField(placeholder: "인증번호 입력", font: .title4)
    
    let titleLabel = UILabel(text: "인증번호가 문자로 전송되었어요", font: .display)
    
    let timeLabel = UILabel(text: "60", font: .title3, color: Asset.Colors.green.color)
    
    let sendMsgButton = RoundedButton(title: "재전송", fontSet: .body3, colorSet: .fill, height: .h40)
    
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, codeTextField, authButton, timeLabel, sendMsgButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        
        codeTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(sendMsgButton.snp.leading).offset(-8)
            make.bottom.equalTo(authButton.snp.top).offset(-72)
            make.height.equalTo(48)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(sendMsgButton.snp.leading).offset(-20)
            make.centerY.equalTo(codeTextField)
        }
        
        
        sendMsgButton.snp.makeConstraints { make in
            make.centerY.equalTo(codeTextField)
            make.trailing.equalToSuperview().inset(16)
        }
        

        authButton.snp.makeConstraints { make in
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

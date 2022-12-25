//
//  AuthPhoneView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class AuthPhoneView: UIView {

    let receiveMsgButton = RoundedButton(title: "인증 문자 받기", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let inputTextField = LineTextField(placeholder: "휴대폰 번호 (-없이 숫자만 입력)", font: .title4)
    
    let titleLabel = UILabel(text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요", font: .display)
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, inputTextField, receiveMsgButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(receiveMsgButton.snp.top).offset(-72)
            make.height.equalTo(48)
        }
        

        receiveMsgButton.snp.makeConstraints { make in
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

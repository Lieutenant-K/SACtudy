//
//  NicknameView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class NicknameView: UIView {

    let nextButton = RoundedButton(title: "다음", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let inputTextField = LineTextField(placeholder: "10자 이내로 입력", font: .title4)
    
    let titleLabel = UILabel(text: "닉네임을 입력해 주세요", font: .display)
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, inputTextField, nextButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        
        inputTextField.keyboardType = .default
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
            make.height.equalTo(48)
        }
        

        nextButton.snp.makeConstraints { make in
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

//
//  AuthCodeViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import UIKit

class AuthCodeViewController: BaseViewController {
    
    let viewModel: AuthCodeViewModel

    let authButton = RoundedButton(title: "인증하고 시작하기", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let codeTextField = LineTextField(placeholder: "인증번호 입력", font: .title4)
    
    let titleLabel = UILabel(text: "인증번호가 문자로 전송되었어요", font: .display)
    
    let timeLabel = UILabel(text: "60", font: .title3, color: Asset.Colors.green.color)
    
    let sendMsgButton = RoundedButton(title: "재전송", fontSet: .body3, colorSet: .fill, height: .h40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bind()
        
    }
    
    func bind() {
        
        viewModel.code
            .bind(to: codeTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validation
            .withUnretained(self)
            .bind { vc, bool in
                let color: ColorSet = bool ? .fill : .disable
                vc.authButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        codeTextField.rx.text
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.inputCode(text: value ?? "")
                vc.viewModel.checkValidation()
            }
            .disposed(by: disposeBag)
        
        authButton.rx.tap
            .withUnretained(self)
            .bind { vc, event in
                vc.viewModel.authorize(completion: {token in })
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .withUnretained(self)
            .bind { vc, value in
                vc.view.makeToast(value)
            }
            .disposed(by: disposeBag)
        
        sendMsgButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.authorize { token in
                    print(token)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, codeTextField, authButton, timeLabel, sendMsgButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(height*0.2)
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

    init(verificationId: String) {
        viewModel = AuthCodeViewModel(verificationId: verificationId)
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("AuthCodeController deinit")
    }
    
}

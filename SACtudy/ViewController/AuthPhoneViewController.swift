//
//  AuthViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/10.
//

import UIKit
import FirebaseAuth
import RxCocoa
import RxSwift
import Toast


class AuthPhoneViewController: BaseViewController {
    
    let viewModel = AuthPhoneViewModel()

    let receiveMsgButton = RoundedButton(title: "인증 문자 받기", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let inputTextField = LineTextField(placeholder: "휴대폰 번호 (-없이 숫자만 입력)", font: .title4)
    
    let titleLabel = UILabel(text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요", font: .display)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        bind()
        inputTextField.text = "010-3736-3736"
    }
    
    func bind() {
        
        let phoneNumber = viewModel.phoneNumber
        
        phoneNumber
            .bind(to: inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validation
            .withUnretained(self)
            .bind { vc, bool in
                let color: ColorSet = bool ? .fill : .disable
                vc.receiveMsgButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        inputTextField.rx.text
            .withUnretained(self)
            .bind { (vc, value) in
                let text = value ?? ""
                vc.viewModel.inputText(text: text)
                vc.viewModel.checkValidation()
                
            }
            .disposed(by: disposeBag)
        
        receiveMsgButton.rx.tap
            .withUnretained(self)
            .bind { vc, event in
                vc.viewModel.requestSMSCode{ id in
                    let next = AuthCodeViewController(verificationId: id)
                    vc.navigationController?.pushViewController(next, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .withUnretained(self)
            .bind { vc, value in
                vc.view.makeToast(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        [titleLabel, inputTextField, receiveMsgButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(height*0.2)
        }
        
        
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
//            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.bottom.equalTo(receiveMsgButton.snp.top).offset(-72)
            make.height.equalTo(48)
        }
        

        receiveMsgButton.snp.makeConstraints { make in
//            make.top.equalTo(inputTextField.snp.bottom).offset(72)
            make.bottom.equalToSuperview().offset(-height*0.43)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        
        
        
        
    }
    
    
    
    
    /*
     func login(credential: PhoneAuthCredential) {
     
     Auth.auth().signIn(with: credential) { authResult, error in
     if let error = error {
     let authError = error as NSError
     if isMFAEnabled, authError.code == AuthErrorCode.secondFactorRequired.rawValue {
     // The user is a multi-factor user. Second factor challenge is required.
     let resolver = authError
     .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
     var displayNameString = ""
     for tmpFactorInfo in resolver.hints {
     displayNameString += tmpFactorInfo.displayName ?? ""
     displayNameString += " "
     }
     self.showTextInputPrompt(
     withMessage: "Select factor to sign in\n\(displayNameString)",
     completionBlock: { userPressedOK, displayName in
     var selectedHint: PhoneMultiFactorInfo?
     for tmpFactorInfo in resolver.hints {
     if displayName == tmpFactorInfo.displayName {
     selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
     }
     }
     PhoneAuthProvider.provider()
     .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
     multiFactorSession: resolver
     .session) { verificationID, error in
     if error != nil {
     print(
     "Multi factor start sign in failed. Error: \(error.debugDescription)"
     )
     } else {
     self.showTextInputPrompt(
     withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
     completionBlock: { userPressedOK, verificationCode in
     let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
     .credential(withVerificationID: verificationID!,
     verificationCode: verificationCode!)
     let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
     .assertion(with: credential!)
     resolver.resolveSignIn(with: assertion!) { authResult, error in
     if error != nil {
     print(
     "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
     )
     } else {
     self.navigationController?.popViewController(animated: true)
     }
     }
     }
     )
     }
     }
     }
     )
     } else {
     self.showMessagePrompt(error.localizedDescription)
     return
     }
     // ...
     return
     }
     // User is signed in
     // ...
     }
     
     
     }
     */
    
    
    
}


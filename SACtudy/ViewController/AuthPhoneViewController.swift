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
    
    let rootView = AuthPhoneView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        
        let input = AuthPhoneViewModel.Input(
            text: rootView.inputTextField.rx.text,
            buttonTap: rootView.receiveMsgButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.phoneNumber
            .bind(to: rootView.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isValidate
            .withUnretained(self)
            .bind {
                let color: ColorSet = $1 ? .fill : .disable
                $0.rootView.receiveMsgButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .withUnretained(self)
            .bind {
                $0.view.makeToast($1)
            }
            .disposed(by: disposeBag)
        
        output.requestSMS
            .withUnretained(self)
            .bind { vc, result in
                switch result {
                case .success(let id):
                    vc.transition(AuthCodeViewController(verificationId: id), isModal: false)
                case .failure(let error):
                    vc.view.makeToast(error.errorMessage)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}


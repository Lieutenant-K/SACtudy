//
//  EmailViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class EmailViewController: BaseViewController {

    let rootView = EmailView()
    
    let viewModel = EmailViewModel()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.inputTextField.text = SignUpData.email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.inputTextField.becomeFirstResponder()
        
    }
    
    func binding() {
        
        let input = EmailViewModel.Input(
            text: rootView.inputTextField.rx.text,
            nextButtonTap: rootView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.isValidate
            .withUnretained(self)
            .bind {
                let color: ColorSet = $1 ? .fill : .disable
                $0.rootView.nextButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        
        output.checkEmail
            .withUnretained(self)
            .bind { vc,value in
                if value.isValid {
                    print("다음 단계로 가자! \(value.email)")
                    SignUpData.email = value.email
                    vc.transition(GenderViewController(), isModal: false)
                } else {
                    vc.view.makeToast("이메일 형식이 올바르지 않습니다.")
                }
            }
            .disposed(by: disposeBag)
        
    }


}

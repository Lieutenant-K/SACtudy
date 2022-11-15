//
//  NicknameViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class NicknameViewController: BaseViewController {

    let rootView = NicknameView()
    
    let viewModel = NicknameViewModel()
    
    var isBack = false
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.inputTextField.becomeFirstResponder()
        
        if isBack {
            view.makeToast("해당 닉네임은 사용할 수 없습니다.")
            isBack = false
        }
    }
    
    func binding() {
        
        let input = NicknameViewModel.Input(
            text: rootView.inputTextField.rx.text,
            nextButtonTap: rootView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.nickname
            .bind(to: rootView.inputTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        output.isValidate
            .withUnretained(self)
            .bind { vc, bool in
                let color: ColorSet = bool ? .fill : .disable
                vc.rootView.nextButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        
        output.checkNickname
            .withUnretained(self)
            .bind { (vc, value) in
                if value.isValid {
                    print("다음 단계로 가자! \(value.nickname)")
                    SignUpData.nickname = value.nickname
                    SignUpData.nicknameViewController = self
                    vc.transition(BirthViewController(), isModal: false)
                } else {
                    vc.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
            }
            .disposed(by: disposeBag)
        
    }

}

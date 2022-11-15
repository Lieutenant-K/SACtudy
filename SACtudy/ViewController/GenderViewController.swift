//
//  GenderViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class GenderViewController: BaseViewController {

    let rootView = GenderView()
    
    let viewModel = GenderViewModel()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [rootView.manButton, rootView.womanButton].forEach {
            $0.isSelected = $0.tag == SignUpData.gender
        }
        rootView.nextButton.changeColor(color: SignUpData.gender >= 0 ? .fill : .disable)
    }
    
    func binding() {

        let input = GenderViewModel.Input(
            manTap: rootView.manButton.rx.tap,
            womanTap: rootView.womanButton.rx.tap,
            nextButtonTap: rootView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.selected
            .withUnretained(self)
            .map { $0.rootView.womanButton.tag == $1 }
            .bind(to: rootView.womanButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.selected
            .withUnretained(self)
            .map { $0.rootView.manButton.tag == $1 }
            .bind(to: rootView.manButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.selected
            .map { $0 >= 0 }
            .withUnretained(self)
            .bind {
                let color: ColorSet = $1 ? .fill : .disable
                $0.rootView.nextButton.changeColor(color: color) }
            .disposed(by: disposeBag)
        
        output.signUp
            .withUnretained(self)
            .bind { vc, response in
                vc.receivedResponse(response: response)
            }
            .disposed(by: disposeBag)

    }
    
    func receivedResponse(response: SeSACResponse) {
        
        switch response {
            
        case .success(let code):
            
            if code == 200 {
                // 회원가입 성공
                self.transition(MainViewController(), isModal: false)
            } else if code == 201 {
                // 이미 가입한 유저
                view.makeToast("이미 가입된 유저입니다.")
            } else if code == 202 {
                // 사용할 수 없는 닉네임
                let vc = SignUpData.nicknameViewController
                vc.isBack = true
                self.navigationController?.popToViewController(vc, animated: true)
            }
            
        case .failure(let error):
            print(error.message)
            
        }
        
    }

}

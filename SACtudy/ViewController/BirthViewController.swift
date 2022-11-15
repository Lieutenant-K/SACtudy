//
//  BirthViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class BirthViewController: BaseViewController {

    let rootView = BirthView()
    
    let viewModel = BirthViewModel()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.yearTextField.becomeFirstResponder()
        
    }
    
    func binding() {

        let input = BirthViewModel.Input(
            date: rootView.datePicker.rx.date,
            nextButtonTap: rootView.nextButton.rx.tap,
            year: rootView.yearTextField.rx.text,
            month: rootView.monthTextField.rx.text,
            day: rootView.dayTextField.rx.text
        )

        let output = viewModel.transform(input, disposeBag: disposeBag)

        output.component
            .map { "\($0.year ?? 0)" }
            .bind(to: rootView.yearTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.component
            .map { "\($0.month ?? 0)" }
            .bind(to: rootView.monthTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.component
            .map { "\($0.day ?? 0)" }
            .bind(to: rootView.dayTextField.rx.text)
            .disposed(by: disposeBag)

        output.isValidate
            .withUnretained(self)
            .bind { vc, bool in
                let color: ColorSet = bool ? .fill : .disable
                vc.rootView.nextButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)

        output.check
            .withUnretained(self)
            .bind { vc, value in
                if value.isValid {
                    SignUpData.birth = value.date
                    vc.transition(EmailViewController(), isModal: false)
                } else {
                    vc.view.makeToast("새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                }
            }
            .disposed(by: disposeBag)

    }

}

extension BirthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func setDelegate() {
        
        [rootView.yearTextField, rootView.monthTextField, rootView.dayTextField]
            .forEach { $0.delegate = self }
        
    }
}

//
//  AuthCodeViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import UIKit
import RxSwift
import RxCocoa

class AuthCodeViewController: BaseViewController {
    
    let viewModel: AuthCodeViewModel
    
    let rootView = AuthCodeView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    func bind() {
        
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        
        let input = AuthCodeViewModel.Input(
            text: rootView.codeTextField.rx.text,
            authButtonTap: rootView.authButton.rx.tap,
            resendMsgButtonTap: rootView.sendMsgButton.rx.tap,
            viewDidAppear: self.rx.viewDidAppear
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.code
            .bind(to: rootView.codeTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isValidate
            .withUnretained(self)
            .bind {
                let color: ColorSet = $1 ? .fill : .disable
                $0.rootView.authButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        output.resetTimer
            .map { String($0) }
            .bind(to: rootView.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.error
            .withUnretained(self)
            .bind {
                $0.view.makeToast($1) }
            .disposed(by: disposeBag)
        
        output.loginResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    let next = SeSACTabBarController()
                    scene.window?.rootViewController = next
                    scene.window?.makeKeyAndVisible()
                case .unregistered:
                    vc.transition(NicknameViewController(), isModal: false)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
    }

    init(verificationId: String) {
        viewModel = AuthCodeViewModel(verificationId: verificationId)
        super.init(nibName: nil, bundle: nil)
    }
    
}

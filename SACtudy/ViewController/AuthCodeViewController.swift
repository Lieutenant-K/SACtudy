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
            .bind { $0.view.makeToast($1) }
            .disposed(by: disposeBag)
        
        output.login
            .withUnretained(self)
            .bind { $0.receivedResponse(response: $1) }
            .disposed(by: disposeBag)
        
    }
    
    func receivedResponse(response: Result<User, SeSACError>) {
        
        switch response {
            
        case .success(let user):
            
            print("뷰 컨트롤러에서 로그인 이벤트 받기 성공! ", user)
            
            transition(MainViewController(), isModal: false)
            
        case .failure(let error):
            
            view.makeToast(error.localizedDescription)
            
            print("로그인 서버 응답 코드: ", error.rawValue)
            
            if error == .notRegistered {
                transition(NicknameViewController(), isModal: false)
            }
        }
        
    }

    init(verificationId: String) {
        viewModel = AuthCodeViewModel(verificationId: verificationId)
        super.init(nibName: nil, bundle: nil)
    }
    
}

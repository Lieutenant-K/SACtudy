//
//  AuthCodeViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import UIKit
import RxSwift

class AuthCodeViewController: BaseViewController {
    
    let viewModel: AuthCodeViewModel
    
    let rootView = AuthCodeView()
    
    var countDown: Disposable?
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTimer()

    }
    
    func bind() {
        
        viewModel.code
            .bind(to: rootView.codeTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.validation
            .withUnretained(self)
            .bind { vc, bool in
                let color: ColorSet = bool ? .fill : .disable
                vc.rootView.authButton.changeColor(color: color)
            }
            .disposed(by: disposeBag)
        
        rootView.codeTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.inputCode(text: value)
                vc.viewModel.checkValidation()
            }
            .disposed(by: disposeBag)
        
        rootView.authButton.rx.tap
            .withUnretained(self)
            .bind { vc, event in
                vc.viewModel.authorize { result in
                    
                    switch result {
                    case .success(let user):
                        // 홈 화면으로 이동
                        break
                    case .failure(let error):
                        if error == .unregisterdUser {
                            // 닉네임 입력화면으로 이동
                        }
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .withUnretained(self)
            .bind { vc, value in
                vc.view.makeToast(value)
            }
            .disposed(by: disposeBag)
        
        rootView.sendMsgButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.resetTimer()
            }
            .disposed(by: disposeBag)
        
//        countDown = viewModel.countDown
//            .map{String($0)}
//            .bind(to: timeLabel.rx.text)
            
        
    }
    
    func resetTimer() {
        countDown?.dispose()
        viewModel.restTime = 60
        countDown = viewModel.countDown
            .map{String($0)}
//            .debug("째깍")
            .bind(to: rootView.timeLabel.rx.text)
    }
    

    init(verificationId: String) {
        viewModel = AuthCodeViewModel(verificationId: verificationId)
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("AuthCodeController deinit")
    }
    
}

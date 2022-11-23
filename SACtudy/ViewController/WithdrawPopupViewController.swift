//
//  WithdrawPopupViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit
import SnapKit
import RxCocoa

class WithdrawPopupViewController: BaseViewController {

    let rootView = PopupView(title: "정말 탈퇴하시겠습니까?", subtitle: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ")
    
    let viewModel = WithdrawPopupViewModel()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color.withAlphaComponent(0.5)
        binding()
    }
    
    func binding() {
        
        let input = WithdrawPopupViewModel.Input(okButtonTap: rootView.okButton.rx.tap)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.withdrawResult
            .bind(with: self) { vc, result in
                
                switch result {
                case .success, .alreadyWithdrawed:
                    vc.sceneDelegate?.setRootViewController(vc: OnboardViewController())
                default:
                    vc.view.makeToast(result.message)
                }
            }
            .disposed(by: disposeBag)
        
        rootView.cancleButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.dismiss(animated: true) }
            .disposed(by: disposeBag)
        
        
    }

}

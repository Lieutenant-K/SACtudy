//
//  CancelStudyViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa

class CancelStudyViewController: BaseViewController {
    let viewModel: CancelStudyViewModel
    let rootView: PopupView
    
    init(viewModel: CancelStudyViewModel, rootView: PopupView) {
        self.viewModel = viewModel
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
        binding()
    }
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color.withAlphaComponent(0.5)
    }
}

extension CancelStudyViewController {
    func binding() {
        let input = CancelStudyViewModel.Input(okButtonTap: rootView.okButton.rx.tap)
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.cancelResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    // 테스트 필요함.
                    vc.dismiss(animated: true)
                    vc.presentingViewController?.navigationController?.popToRootViewController(animated: true)
                case .networkError:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                }
            }
            .disposed(by: disposeBag)
        
        rootView.cancelButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

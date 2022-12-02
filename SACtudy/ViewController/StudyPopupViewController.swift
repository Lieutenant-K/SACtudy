//
//  StudyPopupViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/02.
//

import UIKit
import RxSwift
import RxCocoa

class StudyPopupViewController: BaseViewController {
    
    let popupView: PopupView
    let viewModel: StudyPopupViewModel
    
    init(uid:String, type: PopupType) {
        self.popupView = PopupView(title: type.title, subtitle: type.subtitle)
        self.viewModel = StudyPopupViewModel(uid: uid, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = popupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.black.color.withAlphaComponent(0.5)
        binding()
        
    }
    
    func binding() {
        
        let input = StudyPopupViewModel.Input(
            okButtonTap: popupView.okButton.rx.tap,
            cancelButtonTap: popupView.cancleButton.rx.tap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        input.cancelButtonTap
            .bind(with: self) { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.actionResult
            .bind(with: self) { vc, result in
                switch result {
                case .requestSuccess:
                    vc.presentingViewController?.view.makeToast(result.message)
                    vc.dismiss(animated: true)
                case .acceptSuccess:
                    vc.presentingViewController?.view.makeToast(result.message)
                    vc.dismiss(animated: true)
                case .alreadyRequestToMe:
                    vc.presentingViewController?.view.makeToast(result.message)
                    vc.dismiss(animated: true)
                default:
                    vc.view.makeToast(result.message)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
   

}

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

    let popupView = PopupView(title: "정말 탈퇴하시겠습니까?", subtitle: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ")
    
    override func loadView() {
        view = popupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Asset.Colors.black.color.withAlphaComponent(0.5)
        
        popupView.cancleButton.rx.tap
            .bind { _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }

}

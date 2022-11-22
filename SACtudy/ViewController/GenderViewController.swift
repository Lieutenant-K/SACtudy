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
    
    
    func binding() {
        
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }

        let input = GenderViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
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
        
        output.errorMsg
            .withUnretained(self)
            .bind { $0.view.makeToast($1) }
            .disposed(by: disposeBag)
        
        output.signUpResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    scene.window?.rootViewController = SeSACTabBarController()
                    scene.window?.makeKeyAndVisible()
                case .notAvailableNickname:
                    if let nick = vc.navigationController?.viewControllers.compactMap({ $0 as? NicknameViewController }).first {
                        nick.isBack = true
                        vc.navigationController?.popToViewController(nick, animated: true)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
    }

}

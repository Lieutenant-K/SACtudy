//
//  WaitingForLaunchViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Toast

class WaitingForLaunchViewController: BaseViewController {

    let splashLogo = UIImageView(image: Asset.Images.splashLogo.image)
    let splashText = UIImageView(image: Asset.Images.splashText.image)
    
    let viewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplash()
        binding()
        
    }
    
    func binding() {
        
        let input = LaunchViewModel.Input(viewDidAppear: self.rx.viewDidAppear)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.launchResult
            .withUnretained(self)
            .bind { vc, result in

                switch result {
                case .success:
                    let transit = SeSACTabBarController()
                    transit.modalTransitionStyle = .crossDissolve
                    transit.modalPresentationStyle = .fullScreen
                    vc.transition(transit, isModal: true)
                    
                case .notRegisterd:
                    let transit = NicknameViewController()
                    transit.modalTransitionStyle = .crossDissolve
                    transit.modalPresentationStyle = .fullScreen
                    vc.transition(transit, isModal: true)
                    
                case .authRequried:
                    let transit = AuthPhoneViewController()
                    transit.modalTransitionStyle = .crossDissolve
                    transit.modalPresentationStyle = .fullScreen
                    vc.transition(transit, isModal: true)
                    
                case .networkDisconnect:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                    
                }
                
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func configureSplash() {
        
        [splashLogo, splashText].forEach { view.addSubview($0) }
        
        splashLogo.contentMode = .scaleAspectFit
        splashLogo.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(77)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-70)
            make.height.equalTo(splashLogo.snp.width).multipliedBy(1.2)
        }
        
        splashText.contentMode = .scaleAspectFit
        splashText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(42)
            make.top.equalTo(splashLogo.snp.bottom).offset(35)
            make.centerX.equalTo(splashLogo)
            make.height.equalTo(splashText.snp.width).dividedBy(3)
        }
    }
    
}

//
//  MyInfoSettingViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Then


class MyInfoSettingViewController: BaseViewController {

    let rootView = MyInfoSettingView()
    
    let viewModel = MyInfoSettingViewModel()
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil).then {
        let font = FontSet.title3
        let attr: [NSAttributedString.Key:Any] = [
            .font:font.font,
            .baselineOffset:font.baselineOffset,
            .paragraphStyle:font.paragraph
        ]
        $0.setTitleTextAttributes(attr, for: .normal)
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = UILabel(text: "정보 관리", font: .title3)
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        
    }
    
    func binding() {
        
        let input = MyInfoSettingViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            manButton: rootView.settingView.manButton.rx.tap,
            womanButton: rootView.settingView.womanButton.rx.tap,
            studyText: rootView.settingView.studyTextField.rx.text,
            searchableSwitch: rootView.settingView.allowSwitch.rx.isOn,
            ageSlider: rootView.settingView.ageRangeSlider.rx.value,
            saveButtonTap: saveButton.rx.tap)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.study.bind(to: rootView.settingView.studyTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.searchable.bind(to: rootView.settingView.allowSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        output.gender
            .withUnretained(self)
            .bind{ vc, value in
                [vc.rootView.settingView.manButton, vc.rootView.settingView.womanButton].forEach {
                    let color: ColorSet = $0.tag == value ? .fill : .inactive
                    $0.changeColor(color: color)
                }
            }
            .disposed(by: disposeBag)
        
        output.nickname.bind(to: rootView.cardView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.ageRange.map { "\(Int($0[0])) - \(Int($0[1]))" }
            .bind(to: rootView.settingView.ageRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.ageRange.bind(to: rootView.settingView.ageRangeSlider.rx.value)
            .disposed(by: disposeBag)
        
        output.background
            .map { UIImage(named: $0) }
            .bind(to: rootView.cardView.cardImageView.backgroundImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.sesac
            .map { UIImage(named: $0) }
            .bind(to: rootView.cardView.cardImageView.sesacImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.sesacTitles
            .bind(to: rootView.cardView.titleCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
//        output.errorMessage
//            .withUnretained(self)
//            .bind { vc, text in vc.view.makeToast(text) }
//            .disposed(by: disposeBag)
        
        output.updateResult
            .withUnretained(self)
            .bind { vc, result in
                switch result {
                case .success:
                    vc.navigationController?.popViewController(animated: true)
                case .networkDisconnected:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                }
            }.disposed(by: disposeBag)
        
        
        rootView.settingView.withdrawAction.rx.event
            .bind { [weak self] _ in
                let vc = WithdrawPopupViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    

}

extension MyInfoSettingViewController {
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MyInfoSettingViewModel.Section> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as! RoundedButtonCell
            
            let color: ColorSet = item.count > 0 ? .fill : .inactive
            cell.button.configureButton(text: item.title, font: .title4, color: color)
            
            return cell
            
        })

    }
    
}

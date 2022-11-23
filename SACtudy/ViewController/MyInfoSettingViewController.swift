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
    
    private let saveButton = UIBarButtonItem(text: "저장", font: .title3)
    
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
        
        output.study
            .bind(to: rootView.settingView.studyTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.searchable
            .compactMap{ $0 }
            .bind(to: rootView.settingView.allowSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        output.gender
            .compactMap{ $0 }
            .withUnretained(self)
            .map { $0.rootView.settingView.manButton.tag == $1 }
            .bind(to: rootView.settingView.manButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.gender
            .compactMap{ $0 }
            .withUnretained(self)
            .map { $0.rootView.settingView.womanButton.tag == $1 }
            .bind(to: rootView.settingView.womanButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.nickname
            .bind(to: rootView.cardView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.ageRange
            .compactMap{ $0 }
            .map { "\(Int($0[0])) - \(Int($0[1]))" }
            .bind(to: rootView.settingView.ageRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.ageRange
            .compactMap{ $0 }
            .bind(to: rootView.settingView.ageRangeSlider.rx.value)
            .disposed(by: disposeBag)
        
        output.background
            .map{ $0?.image }
            .bind(to: rootView.cardView.cardImageView.backgroundImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.sesac
            .map { $0?.image }
            .bind(to: rootView.cardView.cardImageView.sesacImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.sesacTitles
            .bind(to: rootView.cardView.titleCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { $0.view.makeToast($1) }
            .disposed(by: disposeBag)
        
        output.updateResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    vc.navigationController?.popViewController(animated: true)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        
        rootView.settingView.withdrawAction.rx.event
            .bind(with: self) { vc, _ in
                let next = WithdrawPopupViewController()
                next.modalTransitionStyle = .crossDissolve
                next.modalPresentationStyle = .overFullScreen
                vc.transition(next, isModal: true)
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

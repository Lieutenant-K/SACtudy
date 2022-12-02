//
//  InspectUserViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/29.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit

class InspectUserViewController: BaseViewController {
    
    let viewModel: InspectUserViewModel
    let backButton = UIBarButtonItem(image: Asset.Images.arrow.image, style: .plain, target: nil, action: nil)
    let deleteStudyButton = UIBarButtonItem(text: "찾기중단", font: .title3)
    
    let rootView = InspectUserView()
    
    init(coordinate: Coordinate) {
        self.viewModel = InspectUserViewModel(coordinate: coordinate)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true

    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = UILabel(text: "새싹 찾기", font: .title3)
        navigationItem.rightBarButtonItem = deleteStudyButton
        navigationItem.leftBarButtonItem = backButton
    }

}

extension InspectUserViewController {
    
    func binding() {
        
        let input = InspectUserViewModel.Input(
            deleteStudyButtonTap: deleteStudyButton.rx.tap,
            refreshButtonTap: rootView.refreshButton.rx.tap,
            changeStudyButtonTap: rootView.changeStudyButton.rx.tap,
            nearUserItemSelected:  rootView.nearUserCollection.rx.itemSelected,
            requestUserItemSelected: rootView.requestUserCollection.rx.itemSelected,
            menuTap: rootView.tabMenu.rx.menuTap
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        backButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true) }
            .disposed(by: disposeBag)
        
        output.nearUserList
            .bind(to: rootView.nearUserCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.nearUserList
            .withUnretained(self)
            .compactMap { vc, section in
                if vc.rootView.tabMenu.currentIndex == 0 {
                    return section.first?.items.isEmpty
                }
                return nil
            }
            .bind(with: self) { vc, bool in
                output.isCurrentEmpty.accept(bool)
                vc.rootView.nearUserCollection.backgroundView?.isHidden = !bool
            }
            .disposed(by: disposeBag)
        
        output.requestUserList
            .withUnretained(self)
            .compactMap { vc, section in
                if vc.rootView.tabMenu.currentIndex == 1 {
                    return section.first?.items.isEmpty
                }
                return nil
            }
            .bind(with: self) { vc, bool in
                output.isCurrentEmpty.accept(bool)
                vc.rootView.requestUserCollection.backgroundView?.isHidden = !bool
            }
            .disposed(by: disposeBag)
        
        output.requestUserList
            .bind(to: rootView.requestUserCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.isCurrentEmpty
            .map{!$0}
            .bind(to: rootView.refreshButton.rx.isHidden, rootView.changeStudyButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        output.actionResult
            .bind(with: self) { vc, result in
                switch result {
                    
                case .deleteSuccess:
                    vc.navigationController?.popToRootViewController(animated: true)
                case .alreadyMatched:
                    print("채팅화면으로 이동")
                case let .changeStudy(coordinate):
                    
                    if let search = vc.navigationController?.viewControllers.compactMap({ $0 as? SearchViewController }).first {
                        vc.navigationController?.popToViewController(search, animated: true)
                    } else {
                        vc.navigationController?.pushViewController(SearchViewController(coordinate: coordinate), animated: true)
                    }
                    
                    
                case .network:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                    
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension InspectUserViewController {
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<InspectUserViewModel.Section> {
        return RxCollectionViewSectionedReloadDataSource { [weak self] dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCardCell.reuseIdentifier, for: indexPath) as? UserCardCell else { return UICollectionViewCell() }
            
            let mainColor: UIColor
            let buttonTitle: String
            
            if collectionView == self?.rootView.nearUserCollection {
                mainColor = Asset.Colors.error.color
                buttonTitle = "요청하기"
                cell.decideStudyButton.rx.tap
                    .bind { _ in
                        let vc = StudyPopupViewController(uid: item.uid, type: .request)
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self?.transition(vc, isModal: true)
                    }
                    .disposed(by: cell.disposeBag)
    
            } else {
                mainColor = Asset.Colors.success.color
                buttonTitle = "수락하기"
                cell.decideStudyButton.rx.tap
                    .bind { _ in
                        let vc = StudyPopupViewController(uid: item.uid, type: .accept)
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self?.transition(vc, isModal: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            
            let colorSet = ColorSet(
                titleColor: Asset.Colors.white.color,
                backgroundColor: mainColor,
                strokeColor: mainColor,
                imageColor: Asset.Colors.white.color
            )
            
            cell.decideStudyButton.configureButton(text: buttonTitle, font: .title3, color: colorSet)
            cell.inputData(user: item)
            
            return cell
            
        }
    }
    
}

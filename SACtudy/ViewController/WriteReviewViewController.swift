//
//  WriteReviewViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WriteReviewViewController: BaseViewController {
    let rootView: WriteReviewView
    let viewModel: WriteReviewViewModel
    
    init(rootView: WriteReviewView, viewModel: WriteReviewViewModel) {
        self.rootView = rootView
        self.viewModel = viewModel
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

extension WriteReviewViewController {
    func binding() {
        let input = WriteReviewViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad,
            comment: rootView.reviewTextView.rx.text,
            registerButtonTap: rootView.registerButton.rx.tap,
            itemSelected: rootView.titleCollection.rx.itemSelected
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.buttonActive
            .withUnretained(self)
            .map{ vc, bool in
                let isValid = bool && vc.rootView.reviewTextView.textColor != vc.rootView.reviewTextView.placeholderColor
                return isValid ? ColorSet.fill : ColorSet.disable
            }
            .bind(with: self) { vc, colorSet in
                vc.rootView.registerButton.changeColor(color: colorSet)
            }
            .disposed(by: disposeBag)
        
        rootView.cancelButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.reputation
            .bind(to: rootView.titleCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.writeResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    vc.dismiss(animated: true) {
                        UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
                    }
                case .networkError:
                    vc.view.makeToast(Constant.networkDisconnectMessage)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension WriteReviewViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<Reputation> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as? RoundedButtonCell else { return UICollectionViewCell() }
            cell.button.configureButton(text: item.title, font: .title4, color: item.count == 0 ? .inactive : .fill)
            return cell
        }
    }
}

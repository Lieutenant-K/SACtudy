//
//  ShopViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/19.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ShopViewController: BaseViewController {
    let rootView: ShopView
    let viewModel: ShopViewModel
    let purchaseButtonTap = PublishRelay<String>()
    
    init(rootView: ShopView, viewModel: ShopViewModel = ShopViewModel()) {
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
        
    } 
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = UILabel(text: "새싹샵", font: .title3)
    }
}

extension ShopViewController {
    func binding() {
        let input = ShopViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad,
            sesacItemSelected: rootView.sesacCollection.rx.modelSelected(ProductModel.self),
            backgroundItemSelected: rootView.backgroundCollection.rx.modelSelected(ProductModel.self),
            purchaseButtonTap: self.purchaseButtonTap,
            saveButtonTap: rootView.saveButton.rx.tap
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.sesacProducts
            .debug()
            .bind(to: rootView.sesacCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.backgroundProducts
            .bind(to: rootView.backgroundCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.currentSesacItem
            .compactMap { $0 }
            .map { Asset.Images.sesacFace(number: $0)?.image }
            .bind(to: rootView.previewImage.sesacImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.currentBackgroundItem
            .compactMap { $0 }
            .map { Asset.Images.sesacBackground(number: $0)?.image }
            .bind(to: rootView.previewImage.backgroundImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.result
            .subscribe(with: self) { vc, result in
                vc.view.makeToast(result.message)
            }
            .disposed(by: disposeBag)
    }
}

extension ShopViewController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ShopViewModel.Section> {
        return RxCollectionViewSectionedReloadDataSource { [weak self] dataSource, collectionView, indexPath, item in
            guard let weakSelf = self else { return UICollectionViewCell() }
            
            let reuseIdentifier = collectionView == weakSelf.rootView.sesacCollection ? ShopSesacCell.reuseIdentifier : ShopBackgroundCell.reuseIdentifier
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            
            cell.inputData(data: item)
            cell.purchaseButton.rx.tap
                .filter { item.isPurchased == false }
                .map { item.type.productIdentifier }
                .bind(to: weakSelf.purchaseButtonTap)
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

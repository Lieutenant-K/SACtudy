//
//  MyInfoViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MyInfoMenuViewController: BaseViewController {
    
    let rootView = MyInfoMenuView()
    
    let viewModel = MyInfoMenuViewModel()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = UILabel(text: "내정보", font: .title3)
    }
    
    func binding() {
        
        let input = MyInfoMenuViewModel.Input(viewWillAppear: self.rx.viewWillAppear)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.sections.bind(to: rootView.collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        rootView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                if indexPath.item == 0 {
                    vc.transition(MyInfoSettingViewController(), isModal: false)
                } else {
                    print("아직 준비중인 메뉴")
                }
            }
            .disposed(by: disposeBag)
        
    }

    
}

extension MyInfoMenuViewController {
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MyInfoMenuViewModel.Section> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let item = dataSource[indexPath]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCell.reuseIdentifier, for: indexPath) as! MyInfoCell
            
            cell.inputData(title: item.title, image: item.image.image, isFirst: indexPath.item == 0)
            
            return cell
        })
    }
    
}

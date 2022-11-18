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

    let infoSettingView = MyInfoSettingView()
    
    override func loadView() {
        view = infoSettingView
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = UILabel(text: "정보 관리", font: .title3)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UILabel(text: "저장", font: .title3))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        
    }
    
    func binding() {
        
        let sections = [Section(items:["1", "2", "3", "4", "5", "6", "7"])]
        
        let relay = PublishRelay<[Section]>()
        
        relay
            .bind(to: infoSettingView.cardView.titleCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        relay.accept(sections)
        
        infoSettingView.settingView.withdrawAction.rx.event
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
    
    struct Section: SectionModelType {
        
        var items: [String]
        
        init(items: [String]) {
            self.items = items
        }
        
        init(original: Section, items: [String]) {
            self = original
            self.items = items
        }
        
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<Section> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as! RoundedButtonCell
            
            return cell
            
        })

    }
    
}

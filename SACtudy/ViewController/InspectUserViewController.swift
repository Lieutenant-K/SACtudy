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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(rootView.nearUserCollection.contentSize.height)
    }

}

extension InspectUserViewController {
    
    func binding() {
        
        let input = InspectUserViewModel.Input(
            deleteStudyButtonTap: deleteStudyButton.rx.tap,
            refreshButtonTap: rootView.refreshButton.rx.tap,
            nearUserItemSelected:  rootView.nearUserCollection.rx.itemSelected
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        backButton.rx.tap
            .bind(with: self) { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true) }
            .disposed(by: disposeBag)
        
        output.nearUserList
            .bind(to: rootView.nearUserCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.requestUserList
            .bind(to: rootView.requestUserCollection.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        
        
        
        output.deleteResult
            .bind(with: self) { vc, result in
                switch result {
                case .success:
                    vc.navigationController?.popToRootViewController(animated: true)
                case .alreadyMatched:
                    print("채팅화면으로 이동")
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension InspectUserViewController {
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<InspectUserViewModel.Section> {
        return RxCollectionViewSectionedReloadDataSource { dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCardCell.reuseIdentifier, for: indexPath) as? UserCardCell else { return UICollectionViewCell() }
            
            
            cell.inputData(user: item)
//            cell.expandButton.tag = indexPath.row
//            cell.expandButton.addTarget(self, action: #selector(self.touchExpandButton(_:)), for: .touchUpInside)
            
            return cell
            
        }
    }
    
//    @objc func touchExpandButton(_ sender: UIButton){
//        if let cell = rootView.nearUserCollection.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? UserCardCell {
//
////            UIView.animate(withDuration: 0.3) { [weak self] in
//                cell.userCardView.titleCollection.isHidden.toggle()
//                cell.userCardView.reviewContainer.isHidden.toggle()
////                self?.rootView.nearUserCollection
////                self?.rootView.nearUserCollection.layoutIfNeeded()
////            }
//
//            if let imageView = cell.expandButton.imageView {
//                imageView.transform = imageView.transform.rotated(by: .pi)
//            }
//
//            rootView.nearUserCollection.reloadData()
//        }
//    }
    
}

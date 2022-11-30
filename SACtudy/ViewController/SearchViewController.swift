//
//  SearchViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/27.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SearchViewController: BaseViewController {
    
    let rootView = SearchView()
    let searchBar = UISearchBar().then {
        
        let font: FontSet = .title4
        let attr: [NSAttributedString.Key:Any] = [
            .font: font.font,
            .baselineOffset: font.baselineOffset,
            .paragraphStyle: font.paragraph,
            .foregroundColor: Asset.Colors.black.color
        ]

        $0.searchTextField.attributedPlaceholder = NSAttributedString(text: "띄어쓰기로 복수 입력이 가능해요", font: font, color: Asset.Colors.gray6.color)
        $0.searchTextField.defaultTextAttributes = attr
        $0.searchTextField.textAlignment = .left
        
    }
    
    let viewModel: SearchViewModel
    
    init(coordinate: Coordinate) {
        viewModel = SearchViewModel(coordinate: coordinate)
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        removeNotificationObserver()
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationItem.titleView = searchBar
    }
    
    func binding() {
        
        let input = SearchViewModel.Input(
            searchButtonTap: rootView.searchButton.rx.tap,
            modelSelected: rootView.tagCollectionView.rx.modelSelected(SearchViewModel.SectionItem.self),
            searchResult: searchBar.rx.searchResult
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        let dataSource = createDataSource()
        
        output.tags
            .bind(to: rootView.tagCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.result
            .bind(with: self) { vc, result in
                switch result {
                case let .success(coordinate):
                    vc.transition(InspectUserViewController(coordinate: coordinate), isModal: false)
                case let .failure(error):
                    vc.view.makeToast(error.message)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
}

extension SearchViewController {
    
    func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<SearchViewModel.Section> {
        
        RxCollectionViewSectionedAnimatedDataSource { dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as? RoundedButtonCell else { return UICollectionViewCell() }
            
            switch item {
            case let .aroundSectionItem(tag, isRecommended, _):
                cell.button.configureButton(text: tag, font: .title4, color: isRecommended ? .recommended : .inactive)
            case let .preferSectionItem(tag, _):
                cell.button.configureButton(text: tag, font: .title4, color: .outline)
                cell.button.configuration?.image = Asset.Images.closeSmall.image.withRenderingMode(.alwaysTemplate)
                cell.button.configuration?.imagePadding = 4
                cell.button.configuration?.imagePlacement = .trailing
            }
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderLabel.reuseIdentifier, for: indexPath) as? SectionHeaderLabel else {
                return UICollectionReusableView() }
            
            let sectionTitle: String
            
            switch dataSource[indexPath.section] {
            case let .around(title, _):
                sectionTitle = title
            case let .prefer(title, _):
                sectionTitle = title
            }
            
            header.label.attributedText = NSAttributedString(text: sectionTitle, font: .title6, color: Asset.Colors.black.color)
            header.label.textAlignment = .left
            
            return header
            
        }
        
    }
}

extension SearchViewController {
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {

        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            
        
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) { [weak self] in
            self?.rootView.animateViewUp(keyboardHeight: frame.height)
            self?.view.layoutIfNeeded()
        }
        
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
//        print(#function, self.description)

        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: duration) { [weak self] in
            self?.rootView.animateViewDown()
            self?.view.layoutIfNeeded()
        }

    }
    
    
}

//
//  ViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/09.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Then

class OnboardViewController: BaseViewController {
    let startButton = RoundedButton(title: "시작하기", fontSet: .body3, colorSet: .fill, height: .h48)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
    }
    
    let pageControl = UIPageControl().then {
        $0.isUserInteractionEnabled = false
        $0.pageIndicatorTintColor = Asset.Colors.gray5.color
        $0.currentPageIndicatorTintColor = Asset.Colors.black.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        binding()
    }
    
    func binding() {
        let items = [
            OnboardItem(title: "위치 기반으로 빠르게\n주위 친구를 확인", highlightString: "위치 기반", image: Asset.Images.onboardingImg1.image),
            OnboardItem(title: "스터디를 원하는 친구를\n찾을 수 있어요", highlightString: "스터디를 원하는 친구",image: Asset.Images.onboardingImg2.image),
            OnboardItem(title: "SeSAC Study",highlightString: nil, image: Asset.Images.onboardingImg3.image)
        ]
        
        let observable = Observable.just(items)
        observable
            .bind(to: collectionView.rx.items(cellIdentifier: OnboardingCell.reuseIdentifier, cellType: OnboardingCell.self)) {
                index, item, cell in
                
                cell.inputData(data: item)
                if index == items.count - 1 {
                    let font = FontFamily.NotoSansKR.medium.font(size: 24)
                    cell.titleLabel.changeAttributes(string: item.title, font: font, color: Asset.Colors.black.color)
                    cell.titleLabel.snp.remakeConstraints { make in
                        make.top.equalTo(16)
                        make.centerX.equalToSuperview()
                    }
                }
            }.disposed(by: disposeBag)
        
        observable
            .map { $0.count }
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind(with: self) { vc, _ in
                let next = AuthPhoneViewController()
                let navi = BaseNavigationController(rootViewController: next)
                navi.modalPresentationStyle = .fullScreen
                navi.modalTransitionStyle = .crossDissolve
                vc.transition(navi, isModal: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureSubviews() {
        [startButton, collectionView, pageControl].forEach { view.addSubview($0) }
        
        startButton.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(1.35)
            $0.bottom.equalTo(startButton.snp.top).offset(-100)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top).offset(-40)
            $0.centerX.equalTo(collectionView)
            $0.height.equalTo(8)
        }
    }

}

extension OnboardViewController {
    struct OnboardItem {
        let title: String
        let highlightString: String?
        let image: UIImage
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { visibleItems, offset, layoutEnvironment in
            
            let page = Int(offset.x/layoutEnvironment.container.contentSize.width)
            
            self.pageControl.currentPage = page
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}

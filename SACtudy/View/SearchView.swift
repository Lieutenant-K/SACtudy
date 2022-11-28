//
//  SearchView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/27.
//

import UIKit
import SnapKit

class SearchView: UIView {

    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.keyboardDismissMode = .onDrag
        $0.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        $0.register(RoundedButtonCell.self, forCellWithReuseIdentifier: RoundedButtonCell.reuseIdentifier)
        $0.register(SectionHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderLabel.reuseIdentifier)
    }
    
    let searchButton = RoundedButton(title: "새싹 찾기", fontSet: .body3, colorSet: .fill, height: .h48)
    
    var buttonBottomConstraint: Constraint?
    var buttonLeadingConstraint: Constraint?
    var buttonTrailingConstraint: Constraint?
    
    private func configureSubviews() {
        
        addSubview(tagCollectionView)
        addSubview(searchButton)
        
        tagCollectionView.snp.makeConstraints{ $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(searchButton.snp.top).offset(-8)
        }
        
        searchButton.snp.makeConstraints { [weak self] make in
            self?.buttonLeadingConstraint = make.leading.equalTo(safeAreaLayoutGuide).inset(16).constraint
            self?.buttonTrailingConstraint = make.trailing.equalTo(safeAreaLayoutGuide).inset(16).constraint
            self?.buttonBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide).offset(0).constraint
        }

    }
    
    func animateViewUp(keyboardHeight: CGFloat) {
        
        let contentHeight = tagCollectionView.contentSize.height + tagCollectionView.contentInset.top
        
        let visibleAreaHeight = tagCollectionView.frame.height + safeAreaInsets.bottom - keyboardHeight
        
        if contentHeight > visibleAreaHeight {
            tagCollectionView.contentOffset.y += contentHeight - visibleAreaHeight

        }
        
        let buttonHeight = keyboardHeight - safeAreaInsets.bottom
        buttonBottomConstraint?.layoutConstraints.first?.constant = -buttonHeight
        buttonLeadingConstraint?.layoutConstraints.first?.constant = 0
        buttonTrailingConstraint?.layoutConstraints.first?.constant = 0
        searchButton.configuration?.background.cornerRadius = 0
    }
    
    func animateViewDown() {
        buttonBottomConstraint?.layoutConstraints.first?.constant = -0
        buttonLeadingConstraint?.layoutConstraints.first?.constant = 16
        buttonTrailingConstraint?.layoutConstraints.first?.constant = -16
        searchButton.configuration?.background.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchView {
    
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environmnet in
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(200), heightDimension: .estimated(32))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
            
            return section
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        
        layout.configuration = config
        
        return layout
    }
    
    
}

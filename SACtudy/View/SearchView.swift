//
//  SearchView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/27.
//

import UIKit

class SearchView: UIView {

    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.keyboardDismissMode = .onDrag
        $0.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        $0.register(RoundedButtonCell.self, forCellWithReuseIdentifier: RoundedButtonCell.reuseIdentifier)
        $0.register(SectionHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderLabel.reuseIdentifier)
    }
    
    let searchButton = RoundedButton(title: "새싹 찾기", fontSet: .body3, colorSet: .fill, height: .h48)
    
    private func configureSubviews() {
        
        addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }

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
                        
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(32))
            
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

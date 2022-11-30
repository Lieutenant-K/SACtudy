//
//  SeSACUserCardCollectionView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import UIKit

class SeSACUserCardCollectionView: UICollectionView {
    
    func configureView() {
        
        collectionViewLayout = createLayout()
        
        register(UserCardCell.self, forCellWithReuseIdentifier: UserCardCell.reuseIdentifier)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 24
        
        let layout =  UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
        
    }
    
    init(){
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

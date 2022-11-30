//
//  SeSACTitleView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit
import SnapKit

class SeSACTitleCollectionView: UICollectionView {
    
    var heightConstraint: Constraint? = nil
    
    override var contentSize: CGSize {
        didSet {
            if contentSize.height > 0 {
                heightConstraint?.update(offset: contentSize.height)
            }
        }
    }

    func createLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, environmnet in
            
            let itemWidth = (environmnet.container.contentSize.width-8)/2
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .estimated(32))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(32))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            return section
            
            
        }
        
    }
    
    private func configureCollectionView() {
        
        collectionViewLayout = createLayout()
        
        register(RoundedButtonCell.self, forCellWithReuseIdentifier: RoundedButtonCell.reuseIdentifier)
        
        isScrollEnabled = false
        
        self.snp.makeConstraints { make in
            self.heightConstraint = make.height.equalTo(100).priority(.required).constraint
        }
        
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configureCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

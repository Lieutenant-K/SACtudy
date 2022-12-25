//
//  MyInfoView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/17.
//

import UIKit
import SnapKit

final class MyInfoMenuView: UIView {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureCollectionView() {
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(MyInfoCell.self, forCellWithReuseIdentifier: MyInfoCell.reuseIdentifier)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

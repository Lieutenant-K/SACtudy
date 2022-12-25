//
//  SeSACUserCardCollectionView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import UIKit
import Then
import SnapKit

class SeSACUserCardCollectionView: UICollectionView {
    
    
    func configureView(backgroundTitle: String) {
        
        collectionViewLayout = createLayout()
        register(UserCardCell.self, forCellWithReuseIdentifier: UserCardCell.reuseIdentifier)
        backgroundView = UIView()
        
        // 백그라운드 뷰 세팅
        let imageView = UIImageView(image: Asset.Images.empty.image)
        let titleLabel = UILabel(text: backgroundTitle, font: .display)
        let subtitleLabel = UILabel(text: "스터디를 변경하거나 조금만 더 기다려주세요!", font: .title4, color: Asset.Colors.gray7.color)
        
        [imageView, titleLabel, subtitleLabel].forEach {
            backgroundView?.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
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
    
    init(backgroudTitle: String){
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configureView(backgroundTitle: backgroudTitle)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

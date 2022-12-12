//
//  ShopView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import SnapKit

class ShopView: UIView {
    let previewImage: SeSACUserImageView
    let saveButton: RoundedButton
    let sesacCollection: UICollectionView
    let backgroundCollection: UICollectionView
    let tabMenu: SeSACTabMenu
    
    init(sesac: UICollectionView, backgrond: UICollectionView) {
        previewImage = SeSACUserImageView()
        saveButton = RoundedButton(title: "저장하기", fontSet: .body3, colorSet: .fill, height: .h40)
        sesacCollection = sesac
        backgroundCollection = backgrond
        tabMenu = SeSACTabMenu(items: [TabMenuItem(title: "새싹", view: sesac), TabMenuItem(title: "배경", view: backgrond)])
        super.init(frame: .zero)
        constraintSubviews()
        configureSubviews()
    }
    
    private func constraintSubviews() {
        [previewImage, tabMenu].forEach { addSubview($0) }
        previewImage.addSubview(saveButton)
        previewImage.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(16)
        }
        saveButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(13)
        }
        tabMenu.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(previewImage.snp.bottom)
        }
    }
    
    private func configureSubviews() {
        sesacCollection.collectionViewLayout = createSesacLayout()
        sesacCollection.register(ShopSesacCell.self, forCellWithReuseIdentifier: ShopSesacCell.reuseIdentifier)
        
        backgroundCollection.collectionViewLayout = createBackgroundLayout()
        backgroundCollection.register(ShopBackgroundCell.self, forCellWithReuseIdentifier: ShopBackgroundCell.reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopView {
    private func createSesacLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.475), heightDimension: .estimated(280))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createBackgroundLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(165))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//
//  ChattingView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import SnapKit

class ChattingView: UIView {
    let topMenu = ChattingTopMenu()
    let textView = ChattingTextView(placeholder: "메세지를 입력하세요")
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var bottomConstraint: Constraint?
    
    func configureSubviews(){
        collectionView.register(MyChatCell.self, forCellWithReuseIdentifier: MyChatCell.reuseIdentifier)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseIdentifier)
        collectionView.register(ChattingAnnounceHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChattingAnnounceHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        
        topMenu.isHidden = true
        topMenu.alpha = 0.0
    }
    
    func constraintSubviews(){
        [textView, collectionView, topMenu].forEach{addSubview($0)}
        
        // 채팅입력 텍스트뷰
        textView.snp.makeConstraints{ [weak self] in
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            self?.bottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).inset(16).constraint
        }
        // 컬렉션 뷰
        collectionView.snp.makeConstraints{
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(textView.snp.top).offset(-8)
        }
        // 메뉴
        topMenu.snp.makeConstraints{
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        constraintSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChattingView {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let suppleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let suppleItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: suppleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 24
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [suppleItem]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

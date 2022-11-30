//
//  UserCardCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class UserCardCell: UICollectionViewCell {
    
    let userCardView = SeSACUserCardView()
    private let reputation = PublishRelay<[Reputation]>()
    private let disposeBag = DisposeBag()
    
    var expandButton: UIButton {
        userCardView.expandButton
    }
    
    private func configureCell() {
        contentView.addSubview(userCardView)
        userCardView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        reputation.bind(to: userCardView.titleCollectionView.rx.items(dataSource: createReputationDataSource()))
            .disposed(by: disposeBag)
        
        expandButton.isUserInteractionEnabled = false
//        expandButton.removeTarget(userCardView, action: #selector(userCardView.touchExpandButton(_:)), for: .touchUpInside)
        
        userCardView.cardImageView.addGestureRecognizer(UITapGestureRecognizer())
    }
    
    func inputData(user: StudyUser) {
        
        userCardView.cardImageView.sesacImageView.image = user.sesac
        
        userCardView.cardImageView.backgroundImageView.image = user.background
        
        userCardView.nicknameLabel.attributedText = NSAttributedString(text: user.nick, font: .title1, color: Asset.Colors.black.color)
        userCardView.nicknameLabel.textAlignment = .left
        
        if let firstReview = user.reviews.first {
            userCardView.reviewContainer.reviewLabel.attributedText = NSAttributedString(text: firstReview, font: .body3, color: Asset.Colors.black.color)
            userCardView.reviewContainer.reviewLabel.textAlignment = .left
        } else {
            userCardView.reviewContainer.reviewLabel.attributedText = NSAttributedString(text: "첫 리뷰를 기다리는 중이에요!", font: .body3, color: Asset.Colors.gray6.color)
            userCardView.reviewContainer.reviewLabel.textAlignment = .left
        }
        
        userCardView.isExpand = user.displayingDetail
        
        reputation.accept([user.reputation])
        
    }
    
    private func createReputationDataSource() -> RxCollectionViewSectionedReloadDataSource<Reputation> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as! RoundedButtonCell
            
            let color: ColorSet = item.count > 0 ? .fill : .inactive
            cell.button.configureButton(text: item.title, font: .title4, color: color)
            
            return cell
            
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

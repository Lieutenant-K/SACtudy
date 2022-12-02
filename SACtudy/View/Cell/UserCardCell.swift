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
    let decideStudyButton = RoundedButton(fontSet: .title3, colorSet: .inactive)
    var disposeBag = DisposeBag()
    
    var expandButton: UIButton {
        userCardView.expandButton
    }
    
    private func configureCell() {
        contentView.addSubview(userCardView)
        contentView.addSubview(decideStudyButton)
        userCardView.snp.makeConstraints {
            $0.edges.equalToSuperview() }
        decideStudyButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(12) }

        
        expandButton.isUserInteractionEnabled = false
        
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
            userCardView.reviewContainer.moreButton.isHidden = false
        } else {
            userCardView.reviewContainer.reviewLabel.attributedText = NSAttributedString(text: "첫 리뷰를 기다리는 중이에요!", font: .body3, color: Asset.Colors.gray6.color)
            userCardView.reviewContainer.reviewLabel.textAlignment = .left
            userCardView.reviewContainer.moreButton.isHidden = true
        }
        
        userCardView.isExpand = user.displayingDetail
        
        Observable.just([user.reputation])
            .bind(to: userCardView.titleCollectionView.rx.items(dataSource: createReputationDataSource()))
            .disposed(by: disposeBag)
        
//        reputation.accept([user.reputation])
        
    }
    
    private func createReputationDataSource() -> RxCollectionViewSectionedReloadDataSource<Reputation> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedButtonCell.reuseIdentifier, for: indexPath) as! RoundedButtonCell
            
            let color: ColorSet = item.count > 0 ? .fill : .inactive
            cell.button.configureButton(text: item.title, font: .title4, color: color)
            
            return cell
            
        })
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

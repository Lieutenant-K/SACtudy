//
//  SeSACUserCardView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SeSACUserCardView: UIView {

    let cardImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
    }
    
    let expandButton = UIButton(type: .custom).then {
        $0.transform = $0.transform.rotated(by: .pi/2)
        $0.setImage(Asset.Images.moreArrow.image, for: .normal)
    }
    
    let nicknameLabel = UILabel(text: "닉네임", font: .title1).then {
        $0.textAlignment = .left
    }
    
    let reviewContainer = SeSACReview()
    
    let titleCollectionView: SeSACTitleCollectionView
    
    private let cardContainerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Asset.Colors.gray2.color.cgColor
    }
    
    private let titleCollection = TitleStackView(title: "새싹 타이틀", view: SeSACTitleCollectionView())
    
    private let stackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.spacing = 24
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        
    }
    
    private let disposeBag = DisposeBag()
    
    private func configureCardView() {
        
    
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(cardImageView.snp.width).multipliedBy(0.56)
        }
        
        addSubview(cardContainerView)
        cardContainerView.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        cardContainerView.addSubview(stackView)
        cardContainerView.addSubview(expandButton)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16) }
        
        
        [nicknameLabel, titleCollection, reviewContainer].forEach {
            stackView.addArrangedSubview($0)
        }
        titleCollection.isHidden = true
        reviewContainer.isHidden = true
        
        expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        expandButton.rx.tap
            .bind { _ in
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.titleCollection.isHidden.toggle()
                    self?.reviewContainer.isHidden.toggle()
                }

                self.expandButton.transform = self.expandButton.transform.rotated(by: .pi)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    init(){
        titleCollectionView = titleCollection.view
        super.init(frame: .zero)
        configureCardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

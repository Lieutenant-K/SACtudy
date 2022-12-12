//
//  ShopBackgroundCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import SnapKit
import RxSwift

final class ShopBackgroundCell: UICollectionViewCell {
    let backgroundImage: UIImageView
    let nameLabel: UILabel
    let descriptionLabel: UILabel
    let purchaseButton: RoundedButton
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        backgroundImage = UIImageView()
        nameLabel = UILabel(text: "배경 이름", font: .title3)
        descriptionLabel = UILabel(text: "설명", font: .body3)
        purchaseButton = RoundedButton(title: "구매", fontSet: .title5, colorSet: .fill)
        super.init(frame: frame)
        constraintSubviews()
        configureSubviews()
    }
    
    private func configureSubviews() {
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 8
        backgroundImage.contentMode = .scaleAspectFill
        
        purchaseButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        purchaseButton.configuration?.background.cornerRadius = 30
        purchaseButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
    }
    
    private func constraintSubviews() {
        let horizontalStack = UIStackView(arrangedSubviews: [nameLabel, purchaseButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, descriptionLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.spacing = 8
        
        [backgroundImage, verticalStack].forEach{
            contentView.addSubview($0) }
        backgroundImage.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.width.equalTo(backgroundImage.snp.height)
        }
        verticalStack.snp.makeConstraints {
            $0.leading.equalTo(backgroundImage.snp.trailing).offset(12)
            $0.centerY.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopBackgroundCell: ProductCell {
    func inputData(data: ProductModel) {
        let image = Asset.Images.self
        let color = Asset.Colors.self
        // 배경 상품 이미지
        if let type = data.type as? BackgroundProducts {
            backgroundImage.image = image.sesacBackground(number: type.rawValue)?.image
        } else { backgroundImage.image = image.sesacBackground0.image }
        
        // 배경 이름
        nameLabel.attributedText = NSAttributedString(text: data.title, font: .title3, color: color.black.color)
        nameLabel.textAlignment = .left
        // 구매 버튼
        purchaseButton.configureButton(text: data.isPurchased ? "보유" : data.price, font: .title5, color: data.isPurchased ? .cancel : .fill)
        purchaseButton.configuration?.background.cornerRadius = 30
        purchaseButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
        // 배경 설명
        descriptionLabel.attributedText = NSAttributedString(text: data.description, font: .body3, color: color.black.color)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
    }
}

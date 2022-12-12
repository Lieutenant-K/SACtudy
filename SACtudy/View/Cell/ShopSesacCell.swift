//
//  ShopSesacCell.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit
import SnapKit
import RxSwift

final class ShopSesacCell: UICollectionViewCell {
    let sesacImage: UIImageView
    let nameLabel: UILabel
    let descriptionLabel: UILabel
    let purchaseButton: RoundedButton
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        sesacImage = UIImageView()
        nameLabel = UILabel(text: "새싹 이름", font: .title2)
        descriptionLabel = UILabel(text: "설명", font: .body3)
        purchaseButton = RoundedButton(title: "구매", fontSet: .title5, colorSet: .fill)
        super.init(frame: frame)
        constraintSubviews()
        configureSubviews()
    }
    
    private func configureSubviews() {
        sesacImage.layer.cornerRadius = 8
        sesacImage.layer.borderColor = Asset.Colors.gray2.color.cgColor
        sesacImage.layer.borderWidth = 1
        
        purchaseButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        purchaseButton.configuration?.background.cornerRadius = 30
        purchaseButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
    }
    
    private func constraintSubviews() {
        let horizontalStack = UIStackView(arrangedSubviews: [nameLabel, purchaseButton])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        
        let verticalStack = UIStackView(arrangedSubviews: [sesacImage, horizontalStack, descriptionLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.spacing = 8
        
        contentView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { $0.edges.equalToSuperview() }
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

extension ShopSesacCell: ProductCell {
    func inputData(data: ProductModel) {
        let image = Asset.Images.self
        let color = Asset.Colors.self
        // 새싹 상품 이미지
        if let type = data.type as? SesacProducts {
            sesacImage.image = image.sesacFace(number: type.rawValue)?.image
        } else { sesacImage.image = image.sesacFace0.image }
        
        // 새싹 이름
        nameLabel.attributedText = NSAttributedString(text: data.title, font: .title2, color: color.black.color)
        nameLabel.textAlignment = .left
        // 구매 버튼
        purchaseButton.configureButton(text: data.isPurchased ? "보유" : data.price, font: .title5, color: data.isPurchased ? .cancel : .fill)
        purchaseButton.configuration?.background.cornerRadius = 30
        purchaseButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
        
        // 새싹 설명
        descriptionLabel.attributedText = NSAttributedString(text: data.description, font: .body3, color: color.black.color)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
    }
}

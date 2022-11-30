//
//  InspectUserView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import UIKit
import SnapKit

class InspectUserView: UIView {

    let nearUserCollection: SeSACUserCardCollectionView
    let requestUserCollection: SeSACUserCardCollectionView
    let tabMenu: SeSACTabMenu
    let changeStudyButton: RoundedButton
    let refreshButton: UIButton
    
    private func configureView() {
        
        addSubview(tabMenu)
        tabMenu.snp.makeConstraints{$0.edges.equalTo(safeAreaLayoutGuide)}
        
        addSubview(changeStudyButton)
        changeStudyButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        addSubview(refreshButton)
        refreshButton.tintColor = Asset.Colors.green.color
        refreshButton.layer.borderColor = refreshButton.tintColor.cgColor
        refreshButton.layer.cornerRadius = 8
        refreshButton.backgroundColor = .white
        refreshButton.layer.borderWidth = 1
        refreshButton.setImage(Asset.Images.refresh.image.withRenderingMode(.alwaysTemplate), for: .normal)
        refreshButton.snp.makeConstraints { make in
            make.leading.equalTo(changeStudyButton.snp.trailing).offset(8)
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.size.equalTo(48)
        }
        
    }
    
    init() {
        self.nearUserCollection = SeSACUserCardCollectionView()
        self.requestUserCollection = SeSACUserCardCollectionView()
        self.tabMenu = SeSACTabMenu(items: [
            TabMenuItem(title: "주변 새싹", view: nearUserCollection),
            TabMenuItem(title: "받은 요청", view: requestUserCollection)
        ])
        self.changeStudyButton = RoundedButton(title: "스터디 변경하기", fontSet: .body3, colorSet: .fill, height: .h48)
        self.refreshButton = UIButton(type: .system)
        super.init(frame: .zero)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

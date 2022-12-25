//
//  MyInfoSettingView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class MyInfoSettingView: UIScrollView {

    let cardView = SeSACUserCardView()
    let settingView = SeSACUserSettingView()
    
    private func configureView() {
        
        let stackView = UIStackView(arrangedSubviews: [cardView, settingView]).then {
            $0.spacing = 24
            $0.axis = .vertical
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentLayoutGuide).inset(16)
            make.horizontalEdges.equalTo(frameLayoutGuide).inset(16)
        }
        
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

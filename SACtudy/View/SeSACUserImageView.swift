//
//  SeSACUserImageView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class SeSACUserImageView: UIView {

    let backgroundImageView = UIImageView(image: Asset.Images.sesacBackground0.image)
    
    let sesacImageView = UIImageView(image: Asset.Images.sesacFace0.image)
    
    private func configureView() {
        
        clipsToBounds = true
        backgroundColor = .lightGray
        layer.cornerRadius = 8
        
        backgroundImageView.contentMode = .scaleAspectFill
        sesacImageView.contentMode = .scaleAspectFit
        
        [backgroundImageView, sesacImageView].forEach {
            addSubview($0)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(15)
            make.centerX.equalToSuperview().offset(-5)
            make.height.equalToSuperview()
            make.width.equalTo(sesacImageView.snp.height)
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

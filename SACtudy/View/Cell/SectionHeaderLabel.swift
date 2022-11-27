//
//  SectionHeaderLabel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/27.
//

import UIKit

class SectionHeaderLabel: UICollectionReusableView {
    
    let label = UILabel(text: "기본 헤더", font: .title6)
    
    private func configureSubview() {
        
        addSubview(label)
        label.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

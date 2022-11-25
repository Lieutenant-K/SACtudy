//
//  MapFloatingButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MapFloatingButton: UIButton {
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        config.image = Asset.Images.search.image
        config.background.backgroundColor = Asset.Colors.black.color
        config.background.cornerRadius = 32
        snp.makeConstraints { $0.size.equalTo(64) }
        configuration = config
        
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1.5
    }
    
    init() {
        super.init(frame: .zero)
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Reactive where Base: MapFloatingButton {
    
    var queueState: Binder<QueueState> {
        return Binder(base) { base, state in
            base.configuration?.image = state.iconImage.image
        }
    }
    
    
}

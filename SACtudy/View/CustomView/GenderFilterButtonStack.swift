//
//  GenderFilterButtonStack.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class GenderFilterButtonStack: UIView {

    let manFilterButton = GenderFilterButton(title: "남자")
    let womanFilterButton = GenderFilterButton(title: "여자")
    let noFilterButton = GenderFilterButton(title: "전체")
    
    private func configureView() {
        
        noFilterButton.configureButton(text: "전체", font: .title3, color: .normal)
        
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.3
        
        let stackView = UIStackView(arrangedSubviews: [noFilterButton, manFilterButton, womanFilterButton]).then {
            $0.axis = .vertical
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Reactive where Base: GenderFilterButtonStack {
    var selectFilter: ControlEvent<GenderFilter> {
        let man = base.manFilterButton.rx.tap.map {GenderFilter.man}
        let woman = base.womanFilterButton.rx.tap.map {GenderFilter.woman}
        let noFilter = base.noFilterButton.rx.tap.map {GenderFilter.noFilter}
        return ControlEvent(events: Observable.merge([man, woman, noFilter]))
    }
    
    var currentFilter: Binder<GenderFilter> {
        return Binder(base) { base, filter in
            base.manFilterButton.isSelected = filter == .man
            base.womanFilterButton.isSelected = filter == .woman
            base.noFilterButton.isSelected = filter == .noFilter
        }
    }
}

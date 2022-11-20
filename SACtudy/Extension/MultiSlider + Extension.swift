//
//  MultiSlider + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/21.
//

import Foundation
import MultiSlider
import RxSwift
import RxCocoa

extension Reactive where Base: MultiSlider {
    
    /// Reactive wrapper for `value` property.
    public var value: ControlProperty<[CGFloat]> {
        return base.rx.controlProperty(editingEvents: .valueChanged) { slider in
            slider.value
        } setter: { slider, value in
            slider.value = value
        }
    }
    
}

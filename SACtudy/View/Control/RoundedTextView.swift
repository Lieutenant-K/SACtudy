//
//  RoundedTextView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class RoundedTextView: UITextView {
    
    let disposeBag = DisposeBag()
    let placeholderColor = Asset.Colors.gray7.color
    let fontSet: FontSet
    var heightConstraint: Constraint?
    var inset: UIEdgeInsets {
        UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    var numberOfLines: CGFloat {
        let height = (contentSize.height - (inset.top + inset.bottom)) / fontSet.paragraph.maximumLineHeight
        return height.rounded()
    }
    
    func configureTextView(placeholder: String){
        // 모서리
        layer.cornerRadius = 8
        
        // 배경색
        backgroundColor = Asset.Colors.gray1.color
        
        // 폰트
        let para = fontSet.paragraph as? NSMutableParagraphStyle
        para?.alignment = .left
        
        let fontSet = FontSet(font: fontSet.font, paragraph: para ?? fontSet.paragraph, baselineOffset: fontSet.baselineOffset)
        let placeholderAttr = NSAttributedString(text: placeholder, font: fontSet, color: placeholderColor)
        attributedText = placeholderAttr
        
        // 플레이스 홀더
        self.rx.editBegin
            .filter { [weak self] in $0 == self?.placeholderColor }
            .bind(with: self) { view, _ in
                view.attributedText = NSAttributedString(text: " ", font: fontSet, color: Asset.Colors.black.color)
                view.text = ""
            }
            .disposed(by: disposeBag)
        
        self.rx.editEnd
            .filter { $0.count == 0 }
            .bind(with: self) { view, _ in
                view.attributedText = placeholderAttr
            }
            .disposed(by: disposeBag)
        
        // 여백
        textContainerInset = inset
        
        // 높이
        self.snp.makeConstraints{ [weak self] in
            self?.heightConstraint = $0.height.equalTo(0).priority(.high).constraint
        }
    }
    
    init(font: FontSet = .body3, placeholder: String){
        self.fontSet = font
        super.init(frame: .zero, textContainer: nil)
        configureTextView(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Reactive where Base:RoundedTextView {
    
    var editBegin: ControlEvent<UIColor?> {
        ControlEvent(events: didBeginEditing.map{base.textColor})
    }
    
    var editEnd: ControlEvent<String> {
        ControlEvent(events: didEndEditing.map{base.text})
    }
    
}

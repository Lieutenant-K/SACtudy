//
//  LineTextField.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/11.
//

import UIKit
import RxSwift
import RxCocoa

class LineTextField: UITextField {
    
    private let line = UIView()
    
    private let inset = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)

    func configureTextField(placeholder: String, font: FontSet) {

        borderStyle = .none
        keyboardType = .decimalPad
        attributedPlaceholder = NSAttributedString(text: placeholder, font: font, color: Asset.Colors.gray7.color)
        attributedText = NSAttributedString(text: "", font: font, color: Asset.Colors.black.color)
        textAlignment = .left
    }
    
    func configureLine() {
        
        addSubview(line)
        line.backgroundColor = Asset.Colors.gray3.color
        line.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    init(placeholder: String, font: FontSet){
        super.init(frame: .zero)
        configureTextField(placeholder: placeholder, font: font)
        configureLine()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}

extension LineTextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds.inset(by: inset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
            super.editingRect(forBounds: bounds.inset(by: inset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds.inset(by: inset))
    }
    
}

extension Reactive where Base: UITextField {
    public var text: ControlProperty<String?> {
        value
    }
}

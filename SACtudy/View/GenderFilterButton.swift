//
//  GenderFilterButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/24.
//

import UIKit

class GenderFilterButton: RoundedButton {

    override func configureButton(text: String, font: FontSet, color: ColorSet) {
        super.configureButton(text: text, font: font, color: color)
        configuration?.background.cornerRadius = 0
        configurationUpdateHandler = { button in
            
            guard let button = button as? RoundedButton else { return }
            
            switch button.state {
                case .selected:
                    button.changeColor(color: .fill)
                default:
                    button.changeColor(color: .normal)
            }
        }
        
    }
    
    init(title: String){
        super.init(title: title, fontSet: .title4, colorSet: .normal, height: .h48)
        
    }

}

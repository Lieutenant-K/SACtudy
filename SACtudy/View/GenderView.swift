//
//  GenderView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class GenderView: UIView {

    let nextButton = RoundedButton(title: "다음", fontSet: .body3, colorSet: .disable, height: .h48)
    
    let manButton = RoundedButton(title: "남자", image: UIImage(named: "man"), fontSet: .title2, colorSet: .inactive)
    let womanButton = RoundedButton(title: "여자", image: UIImage(named: "woman"), fontSet: .title2, colorSet: .inactive)
    
    let titleLabel = UILabel(text: "성별을 선택해 주세요", font: .display)
    let subtitleLabel = UILabel(text: "새싹 찾기 기능을 이용하기 위해서 필요해요!", font: .title2, color: Asset.Colors.gray7.color)
    
    func createStackView() -> UIStackView {
        
        return UIStackView(arrangedSubviews: [manButton, womanButton]).then { view in
            view.axis = .horizontal
            view.alignment = .fill
            view.distribution = .fillEqually
            view.spacing = 10
        }
        
    }
    
    func configureGenderButton() {
        womanButton.tag = 0
        manButton.tag = 1
        [manButton, womanButton].forEach {
            $0.configuration?.imagePlacement = .top
            $0.configurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.background.backgroundColor = Asset.Colors.whitegreen.color
                default:
                    button.configuration?.background.backgroundColor = Asset.Colors.white.color
                }
            }
        }
        
    }
 
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        let stackView = createStackView()
        
        [titleLabel, subtitleLabel, stackView, nextButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-32)
            make.height.equalTo(120)
        }
        

        nextButton.snp.makeConstraints { make in
//            make.top.equalTo(inputTextField.snp.bottom).offset(72)
            make.bottom.equalToSuperview().offset(-height*0.43)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureGenderButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

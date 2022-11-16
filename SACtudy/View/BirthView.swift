//
//  BirthView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/13.
//

import UIKit

class BirthView: UIView {

    let nextButton = RoundedButton(title: "다음", fontSet: .body3, colorSet: .disable, height: .h48)
    let yearTextField = LineTextField(placeholder: "1990", font: .title4)
    let monthTextField = LineTextField(placeholder: "1", font: .title4)
    let dayTextField = LineTextField(placeholder: "1", font: .title4)
    let titleLabel = UILabel(text: "생년월일을 알려주세요", font: .display)
    let datePicker = UIDatePicker().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.date = SignUpData.birth.toBirthDate ?? Date()
        $0.maximumDate = Date()
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
    }
    
    func createStackView() -> UIStackView {
        
        let yearView = UIView().then { view in
            
            let label = UILabel(text: "년", font: .title2)
            
            [label, yearTextField].forEach { view.addSubview($0) }
            
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(yearTextField)
                make.trailing.equalToSuperview()
            }
            
            yearTextField.inputView = datePicker
            yearTextField.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(label.snp.leading).offset(-4)
            }
            
        }
        
        let monthView = UIView().then { view in
            
            let label = UILabel(text: "월", font: .title2)
            
            [label, monthTextField].forEach { view.addSubview($0) }
            
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(monthTextField)
                make.trailing.equalToSuperview()
            }
            
            monthTextField.inputView = datePicker
            monthTextField.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(label.snp.leading).offset(-4)
            }
            
        }
        
        let dayView = UIView().then { view in
            
            let label = UILabel(text: "일", font: .title2)
            
            [label, dayTextField].forEach { view.addSubview($0) }
            
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(dayTextField)
                make.trailing.equalToSuperview()
            }
            
            dayTextField.inputView = datePicker
            dayTextField.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(label.snp.leading).offset(-4)
            }
            
        }
        
        return UIStackView(arrangedSubviews: [yearView, monthView, dayView]).then { view in
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.spacing = 20
            view.alignment = .fill
        }
    
    }
    
    func configureSubviews() {
        
        let height = UIScreen.main.bounds.height
        
        let stackView = createStackView()
        
        [titleLabel, stackView, nextButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self).offset(height*0.2)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
//            make.top.equalTo(titleLabel.snp.bottom).offset(64)
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
            make.height.equalTo(48)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

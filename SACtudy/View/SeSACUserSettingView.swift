//
//  SeSACUserSettingView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/18.
//

import UIKit

class SeSACUserSettingView: UIView {

    let manButton = RoundedButton(title: "남자", fontSet: .body3, colorSet: .inactive, height: .h48)
    let womanButton = RoundedButton(title: "여자", fontSet: .body3, colorSet: .inactive, height: .h48)
    let studyTextField = LineTextField(placeholder: "스터디를 입력해 주세요", font: .title4)
    let allowSwitch = UISwitch().then {
        $0.onTintColor = Asset.Colors.green.color
    }
    let ageRangeSlider = UISlider().then {
        $0.minimumTrackTintColor = Asset.Colors.green.color
    }
    let ageRangeLabel = UILabel(text: "00 - 00", font: .title3, color: Asset.Colors.green.color)
    let withdrawAction = UITapGestureRecognizer()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 16
    }
    
    private func makeGenderView() -> UIView {
        
        return UIView().then {
            let label = UILabel(text: "내 성별", font: .title4)
            $0.addSubview(label)
            $0.addSubview(manButton)
            $0.addSubview(womanButton)
            
            label.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            
            womanButton.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
            }
            
            manButton.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.trailing.equalTo(womanButton.snp.leading).offset(-8)
            }
        }
        
    }
    
    private func makeStudyView() -> UIView {
        
        return UIView().then {
            let label = UILabel(text: "자주 하는 스터디", font: .title4)
            $0.addSubview(label)
            $0.addSubview(studyTextField)
            
            label.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            
            studyTextField.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.height.equalTo(48)
            }
        }
        
    }
    
    private func makeAllowSearchView() -> UIView {
        
        return UIView().then {
            let label = UILabel(text: "내 번호 검색 허용", font: .title4)
            $0.addSubview(label)
            $0.addSubview(allowSwitch)
            
            label.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            
            allowSwitch.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(10)
                make.trailing.equalToSuperview()
                make.height.equalTo(28)
                make.width.equalTo(52)
            }
        }
        
    }
    
    private func makeAgeRangeView() -> UIView {
        
        return UIView().then {
            let label = UILabel(text: "상대방 연령대", font: .title4)
            $0.addSubview(label)
            $0.addSubview(ageRangeSlider)
            $0.addSubview(ageRangeLabel)
            
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.top.equalTo(13)
            }
            
            ageRangeLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalTo(label)
            }
            
            ageRangeSlider.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(13)
                make.height.equalTo(24)
                make.leading.bottom.equalToSuperview()
                make.trailing.equalTo(-13)
            }
        }
        
    }
    
    private func makeWithdrawView() -> UIView {
        
        return UIView().then {
            let label = UILabel(text: "회원탈퇴", font: .title4)
            
            $0.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(13)
                make.leading.equalToSuperview()
            }
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
    }
    
    func configureSettingView() {
        
        [makeGenderView(), makeStudyView(), makeAllowSearchView(), makeAgeRangeView()].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        
        let withdraw = makeWithdrawView()
        withdraw.addGestureRecognizer(withdrawAction)
        
        addSubview(withdraw)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        withdraw.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(32)
            make.trailing.leading.bottom.equalToSuperview()
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSettingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

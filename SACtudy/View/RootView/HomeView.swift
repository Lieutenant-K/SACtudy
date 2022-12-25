//
//  HomeView.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/24.
//

import UIKit
import MapKit
import SnapKit
import Then

class HomeView: UIView {
    
    let floatingButton = MapFloatingButton()
    let centerPin = UIImageView(image: Asset.Images.mapMarker.image)
    let mapView = HomeMapView()
    let genderFilter = GenderFilterButtonStack()
    let gpsButton = RoundedButton(image: Asset.Images.place.image, fontSet: .title3, colorSet: .normal)
    
    private func configureSubviews() {
        
        addSubview(mapView)
        mapView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        addSubview(genderFilter)
        genderFilter.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        addSubview(gpsButton)
        gpsButton.layer.shadowOpacity = 0.3
        gpsButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        gpsButton.snp.makeConstraints {
            $0.top.equalTo(genderFilter.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.size.equalTo(genderFilter.snp.width)
        }
        
        addSubview(centerPin)
        centerPin.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(centerPin.intrinsicContentSize)
        }
        
        addSubview(floatingButton)
        floatingButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
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

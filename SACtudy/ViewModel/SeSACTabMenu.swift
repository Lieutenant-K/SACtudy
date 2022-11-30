//
//  SeSACMenuButton.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/29.
//

import UIKit
import Then
import SnapKit

final class SeSACTabMenu: UIView {
    
    var items: [TabMenuItem]
    private var buttons = [UIButton]()
    private let container = UIView()

    private func configureView() {
        
        buttons = items.enumerated().map { (index, item) in
            let button = createButton(title: item.title)
            button.tag = index
            button.addTarget(self, action: #selector(switchView(_:)), for: .touchUpInside)
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.trailing.leading.top.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        items.forEach {
            container.addSubview($0.view)
            $0.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        
        if let first = buttons.first {
            switchView(first)
        }
        
    }
    
    private func createButton(title: String) -> UIButton {
        
        return UIButton().then {
            
            // Bottom Line
            let line = UIView()
            line.backgroundColor = Asset.Colors.gray2.color
            
            $0.addSubview(line)
            line.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            // Attributed String
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(text: title, font: .title4, color: Asset.Colors.gray6.color)
            config.background.backgroundColor = .white
            $0.configuration = config
            
            
            // UpdateHandler
            $0.configurationUpdateHandler = { button in
                
                let attr: AttributedString
                
                switch button.state {
                case .selected:
                    attr = AttributedString(text: title, font: .title3, color: Asset.Colors.green.color)
                    line.snp.updateConstraints { $0.height.equalTo(2) }
                    line.backgroundColor = Asset.Colors.green.color
                    
                default:
                    attr = AttributedString(text: title, font: .title4, color: Asset.Colors.gray6.color)
                    line.snp.updateConstraints { $0.height.equalTo(1) }
                    line.backgroundColor = Asset.Colors.gray2.color
                }
                
                button.configuration?.attributedTitle = attr
            }
        }
        
    }
    
    @objc func switchView(_ sender: UIButton) {
        buttons.forEach { $0.isSelected = $0.tag == sender.tag }
        container.bringSubviewToFront(items[sender.tag].view)
    }
    
    init(items: [TabMenuItem]) {
        self.items = items
        super.init(frame: .zero)
        configureView()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  BaseNavigationController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/06.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureController()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureController() {
        let dummy = emptyImage(with: CGSize(width: 0.01, height: 0.01))
        let appear = UINavigationBarAppearance()
        appear.configureWithDefaultBackground()
        appear.backgroundColor = Asset.Colors.white.color
        appear.shadowColor = .black.withAlphaComponent(0.04)
        appear.setBackIndicatorImage(dummy, transitionMaskImage: dummy)
        
        navigationBar.tintColor = Asset.Colors.black.color
        navigationBar.scrollEdgeAppearance = appear
        navigationBar.standardAppearance = appear
    }
    
    private func emptyImage(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//
//  UIApplication + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import Foundation
import UIKit

extension UIApplication {
    
    var rootViewController: UIViewController? {
        (connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
    }
    
    static func topViewController(base: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

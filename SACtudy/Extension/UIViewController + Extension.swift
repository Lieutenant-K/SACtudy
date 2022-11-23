//
//  UIViewController + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/14.
//

import UIKit
import RxCocoa
import RxSwift

public extension UIViewController {
    
    internal var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
    
    func transition<T: UIViewController>(_ viewController: T, isModal: Bool) {
        
        if !NetworkMonitor.shared.isConnected {
            view.makeToast(Constant.networkDisconnectMessage)
            return
        }
        
        if isModal {
            self.present(viewController, animated: true)
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

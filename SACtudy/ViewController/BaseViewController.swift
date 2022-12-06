//
//  BaseViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationItem()
        addTapGesture()
        
    }
    
    func addTapGesture() {
        
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    
        gesture.rx.event
            .withUnretained(self)
            .bind { vc, _ in
                vc.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    func configureNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(image: Asset.Images.arrow.image, style: .done, target: nil, action: nil)
        navigationItem.backButtonTitle = ""
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("fatal error")
    }
    
    deinit {
        print(String(describing: Self.self), "deinit")
    }

}

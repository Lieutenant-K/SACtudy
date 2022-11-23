//
//  MainViewController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/16.
//

import UIKit

class HomeViewController: BaseViewController {
    
    let rootView = HomeView()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationController?.isNavigationBarHidden = true
    }

}

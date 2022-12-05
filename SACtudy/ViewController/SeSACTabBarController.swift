//
//  SeSACTabBarController.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/19.
//

import UIKit
import CoreLocation

final class SeSACTabBarController: UITabBarController {

    private func configureTabBarItems() {
        
        let manager = CLLocationManager()
        let home = HomeViewController(manager: manager)
        manager.delegate = home
        home.tabBarItem = UITabBarItem(title: "홈", image: Asset.Images.home.image, tag: 0)
        
        let shop = ShopViewController()
        shop.tabBarItem = UITabBarItem(title: "새싹샵", image: Asset.Images.shop.image, tag: 1)
        
        let friends = FriendsViewController()
        friends.tabBarItem = UITabBarItem(title: "새싹친구", image: Asset.Images.friends.image, tag: 2)
        
        let myInfo = MyInfoMenuViewController()
        myInfo.tabBarItem = UITabBarItem(title: "내정보", image: Asset.Images.my.image, tag: 3)
        
        viewControllers = [home, shop, friends, myInfo].map {
            let appear = UINavigationBarAppearance()
            appear.configureWithDefaultBackground()
            appear.backgroundColor = Asset.Colors.white.color
            appear.shadowColor = .black.withAlphaComponent(0.04)
            let navi = UINavigationController(rootViewController: $0)
            navi.navigationBar.scrollEdgeAppearance = appear
            navi.navigationBar.standardAppearance = appear
            return navi
        }
        
        let font = FontSet.body4
        
        let attr: [NSAttributedString.Key:Any] = [
            .font:font.font,
            .baselineOffset:font.baselineOffset,
            .paragraphStyle:font.paragraph
        ]
        
        let itemAppear = UITabBarItemAppearance(style: .stacked)
        itemAppear.normal.titleTextAttributes = attr
        itemAppear.selected.titleTextAttributes = attr
        itemAppear.disabled.titleTextAttributes = attr
        
        let appear = UITabBarAppearance()
        appear.configureWithDefaultBackground()
        appear.backgroundColor = .white
        appear.shadowColor = .black.withAlphaComponent(0.04)
        appear.stackedLayoutAppearance = itemAppear
        
        
        tabBar.tintColor = Asset.Colors.green.color
        tabBar.standardAppearance = appear
        tabBar.scrollEdgeAppearance = appear
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItems()
        
    }
    



}

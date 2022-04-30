//
//  TabBarController.swift
//  AppStrore
//
//  Created by Finley on 2022/04/30.
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    
    //TabBar
    //탭바선언
    private lazy var todayViewController: UIViewController = {
        let viewController = TodayViewController()
        //탭바 타이틀, 아이콘이미지
       let tabBarItem = UITabBarItem(title: "투데이",
                                     image: UIImage(systemName:"mail"),
                                     tag: 0) //-> 탭의 순서 (0번째탭)
        viewController.tabBarItem = tabBarItem //UIViewController에 탭바아이템 적용
        return viewController
    }()
    

    private lazy var appViewController: UIViewController = {
        let viewController = UIViewController()
        let tabBarItem = UITabBarItem(title: "앱",
                                      image: UIImage(systemName:"square.stack.3d.up"),
                                      tag: 1)
        viewController.tabBarItem = tabBarItem
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [todayViewController, appViewController] //멤버수 = 탭바의 수
    }
}

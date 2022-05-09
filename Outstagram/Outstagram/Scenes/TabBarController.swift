//
//  TabBarController.swift
//  Outstagram
//
//  Created by Finley on 2022/05/08.
//

import UIKit

class TabBarController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let profileViewcontroller = UINavigationController(rootViewController: ProfileViewController())
        profileViewcontroller.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        //UITabBarController의 viewControllers변수에 feedViewController와 profileViewController를 추가
        viewControllers = [feedViewController, profileViewcontroller]
        

    }
  }
 

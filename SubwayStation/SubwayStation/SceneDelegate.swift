//
//  SceneDelegate.swift
//  SubwayStation
//
//  Created by Finley on 2022/05/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = UINavigationController(rootViewController: StationSearchViewController()) 
        window?.makeKeyAndVisible()
    }
}


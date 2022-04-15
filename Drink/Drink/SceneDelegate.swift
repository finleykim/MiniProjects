//
//  SceneDelegate.swift
//  Drink
//
//  Created by Finley on 2022/04/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    
    //사용자가 앱을 열어서 scene이 Active상태가 되었을 시점에 실행되는 메서드
    func sceneWillResignActive(_ scene: UIScene) {
        //뱃지의 넘버를 0으로 만든다 (없앤다)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}


//
//  SceneDelegate.swift
//  NetflixStyleSampleApp
//
//  Created by Finley on 2022/04/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //windowScene선언
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        //layout설정부분
        //layout의 경우 필수적으로 UICollectionViewFlowLayout를 가지고있어야하기 때문에 기본으로 설정해둔다.
        let layout = UICollectionViewFlowLayout()
        //HoeViewContoller불러오기. HomeViewController는 collectionview이기때문에 collectionViewLayout을 필수로 넣어줘야한다.
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        //navigationcontroller와 연결된 rootviewcontroller설정
        let rootNavigationController = UINavigationController(rootViewController: homeViewController)
        
        //HomeViewController를 루트뷰로 가지고있는 navigationController지정
        self.window?.rootViewController = rootNavigationController
        //실제로 설정한 값들을 보이게하기
        self.window?.makeKeyAndVisible()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


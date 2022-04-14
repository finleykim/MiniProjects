
import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
        FirebaseApp.configure()
        Installations.installations().authTokenForcingRefresh(true, completion: { (result, error) in
            //에러가 발생하면 프린트
            if let error = error {
                print("Error fetching token: \(error)")
                return
            }
            //결과값이 있다면
            guard let result = result else { return }
            print("Installation auth token: \(result.authToken)")
        })
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
   
    }


}


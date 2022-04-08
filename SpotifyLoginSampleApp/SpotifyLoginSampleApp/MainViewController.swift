//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Finley on 2022/04/07.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController{
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pop제스쳐 방지
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
환영합니다
\(email)님
"""
       
        let ismEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !ismEmailSignIn
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
        
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
}

//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by Finley on 2022/04/07.
//

import UIKit

class MainViewController: UIViewController{
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pop제스쳐 방지
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

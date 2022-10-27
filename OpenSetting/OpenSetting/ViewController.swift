//
//  ViewController.swift
//  OpenSetting
//
//  Created by finley on 2022/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        if #available(iOS 15.4, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenNotificationSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}


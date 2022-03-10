//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit

class CodePushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

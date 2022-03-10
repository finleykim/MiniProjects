//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit

class CodePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

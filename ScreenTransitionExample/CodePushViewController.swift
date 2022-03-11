//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit


class CodePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String? //인스턴스생성
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name{
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }

      
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.delegate?.sendData(name: "Push Gunter")
        self.navigationController?.popViewController(animated: true)
    }
    

}

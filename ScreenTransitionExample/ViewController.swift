//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    @IBAction func tapCodePushButton(_ sender: UIButton) {
        
        //스토리보드에 있는 뷰컨트롤러를 인스턴스화 시키는 과정
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") else{ return }
        self.navigationController?.pushViewController(viewController, animated: true)
                                                    //전환화면인스턴스
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
   guard let viewController =
        self.storyboard?.instantiateViewController(identifier: "CodePresentViewController")
        else{ return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}


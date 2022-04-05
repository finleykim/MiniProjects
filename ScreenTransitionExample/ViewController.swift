//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate  {

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController 뷰가 로드 되었다.")
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController 뷰가 로드 되었다.")
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController 뷰가 로드 되었다.")
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController 뷰가 로드 되었다.")
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController 뷰가 로드 되었다.")
      
    }
    
 
    

    @IBAction func tapCodePushButton(_ sender: UIButton) {
        
        //스토리보드에 있는 뷰컨트롤러를 인스턴스화 시키는 과정
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else{ return } //CodePushViewController로 다운캐스팅 - name프로퍼티 접근가능해짐
        //다른화면으로 push되기 전에 프로퍼티에 값을 넘겨주면 전환된 화면으로 데이터를 전달할 수 있다
        viewController.name = "Gunter"
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
                                                    //전환화면인스턴스
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
   guard let viewController =
        self.storyboard?.instantiateViewController(identifier: "CodePresentViewController")
        as? CodePresentViewController else{ return } //CodePresentViewController로 다운캐스팅 - name프로퍼티 접근가능해짐
        //다른화면으로 present되기 전에 프로퍼티에 값을 넘겨주면 전환된 화면으로 데이터를 전달할 수 있다
        //viewController.modalPresentationStyle = .fullScreen
        viewController.name = "Gunter"
        viewController.delegate = self //delegate에 접근한 후 self로 초기화하면 delegate로 위임받게된다.
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SeguePushViewController{
            viewController.name = "Gunter"
        }
    }
    
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
    
}


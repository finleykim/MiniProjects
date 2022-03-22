//
//  ViewController.swift
//  TodoList
//
//  Created by Finley on 2022/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        //알럿을 표시
        let alert = UIAlertController(title: "할 일 등록", message: "할 일을 입력해주세요", preferredStyle: .alert)
        //알럿버튼을 눌렀을 때 파라미터에 정의된 클로저함수가 호출되기 때문에 사용자가 알럿버튼을 눌렀을 때 실행해야할 행동을 handler 클로저에 정의
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: {_ in
            
        })
       //취소버튼생성
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil) //취소버튼을 누르면 별다른 액션을 취하지 않을 것이기 떄문에 handler : nil
        
        //함수호출 후 정의한 불변프로퍼티를 매개변수로 넣어준다
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        
        //알럿에 할일을 입력할 텍스트필드 삽입           //알럿을 표시하기 전에 텍스트필드를 구성하기위한 클로저(반환값없음, 텍스트필드의 객체에 해당하는 단일 매개변수를 사용)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "할 일을 입력해주세요 "})
        self.present(alert, animated: true, completion: nil)
        
    
    }
}



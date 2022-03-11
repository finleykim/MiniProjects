//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by Finley on 2022/03/10.
//

import UIKit
protocol SendDataDelegate: AnyObject{ //프로토콜정의
    func sendData(name: String) //name이라는 매개변수를 넘길 수 있도록 정의
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
        var name:String? //인스턴스생성
    weak var delegate: SendDataDelegate? //프로토콜타입의 변수 정의 - Delegate변수는 위임할 준비 완료
    //weak:delegate를 사용할때 delegate변수에는 weak라는 키워드를 붙여야함
    //만약 weak키워드를 생략할 경우 강한순환참조가 걸려 메모리 누수가 발생할 우려가 있음
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name{
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }


    }
    

    @IBAction func tapBackButton(_ sender: UIButton) {
        //dismiss를 호출하기 전에 코드를 작성
        self.delegate?.sendData(name: "Present Gunter")
        //데이터를 전달받은 뷰컨트롤러에서 샌드데이터델리게이트프로토콜을 채택 - 델리게이트 위임받으면 - 샌드데이터델리게이트 프로토콜을 채택한 이전화면인 뷰컨트롤러에서 정의된 샌드데이터함수가 실행된다
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

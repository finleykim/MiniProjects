//
//  EnterEmailController.swift
//  SpotifyLoginSampleApp
//
//  Created by Finley on 2022/04/07.
//

import UIKit
import FirebaseAuth

class EnterEmailController: UIViewController{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        //navigation bar 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증 (각각의 텍스트필드에 적힌 텍스트를 넘겨주어야하기때문에 해당프로프티생성, nil값일경우 "" 할당
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //Firebase에서 제공하는 *를 이용하여
        //신규사용자생성
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            guard let self = self else { return }
            //에러발생시
            if let error = error{
                let code = (error as NSError).code
                    switch code{
                    case 17007: //이미 가입한 계정인 경우
                        self.loginUser(withEmail: email, password: password)
                    default: // 그 외의경우 발생한 에러의 디스크립션표시
                        self.errorLabel.text = error.localizedDescription
                    }
            }else{
                self.showMainViewController()
            }
            
            
        }
        
    }
    
    //계정이 잘 생성되었다면 MainViewController로이동하는 메서드구현
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                            // ㄴ스토리보드파일명
        //스토리보드의 MainViewController 인스턴스화
        let mainViewContoller = storyboard.instantiateViewController(identifier: "MainViewContorller")
        //navigationController를 통해 mainViewController띄우기
        navigationController?.show(mainViewContoller, sender: nil)
    }
    
    
    private func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] _, error in
            guard let self = self else { return }
            if let error = error{
                self.errorLabel.text = error.localizedDescription
            } else{
                self.showMainViewController()
            }
            
        })
    }
    
}

extension EnterEmailController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let ispasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !ispasswordEmpty
    }
}

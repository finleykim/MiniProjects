//
//  EnterEmailController.swift
//  SpotifyLoginSampleApp
//
//  Created by Finley on 2022/04/07.
//

import UIKit

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

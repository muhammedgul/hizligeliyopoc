//
//  LoginVC.swift
//  HızlıGeliyo POC
//
//  Created by Muhammed Gül on 8.09.2020.
//  Copyright © 2020 Muhammed Gül. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        turnButtonOff()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupTextFields() {
        let textFields = [emailTextField,passwordTextField]
        
        for textField in textFields as! [UITextField] {
            textField.delegate = self
            textField.borderStyle = .none
            textField.layer.cornerRadius = emailTextField.frame.height / 2
            textField.layer.masksToBounds = false
            textField.layer.backgroundColor = UIColor.white.cgColor
            
            textField.layer.shadowOffset = CGSize(width: 1, height: 10)
            textField.layer.shadowOpacity = 0.1
            textField.layer.shadowRadius = 10
            textField.layer.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor
        }
    }
    
}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            view.endEditing(true)
        }
        return true
    }
    
    // prevent keyboard from hiding stuff
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var tempConstraint: NSLayoutConstraint? = nil
        for constraint in view.constraints {
            if constraint.identifier == "topConstraint" {
                tempConstraint = constraint
            }
        }
        guard let topConstraint = tempConstraint else {
            return
        }
        
        switch textField {
        case emailTextField:
            topConstraint.constant = -25
        case passwordTextField:
            topConstraint.constant = -50
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        for constraint in view.constraints {
            if constraint.identifier == "topConstraint" {
                constraint.constant = 0
            }
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email.count > 0 && password.count > 0 {
                turnButtonOn()
            } else {
                turnButtonOff()
            }
        } else {
            turnButtonOff()
        }
    }
    
    private func turnButtonOn() {
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }
    private func turnButtonOff() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
    
}

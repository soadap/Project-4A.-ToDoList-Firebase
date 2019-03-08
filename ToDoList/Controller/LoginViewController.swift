//
//  LoginViewController.swift
//  ToDoList
//
//  Created by soadap on 2/7/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {

    }
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        guard !(emailText.text == "") else {
            showMessage("Enter email", self)
            return
        }
        guard !(passwordText.text == "") else {
            showMessage("Enter password", self)
            return
        }
        
        Service.autorizeFirebase(username: emailText.text!, password: passwordText.text!, controller: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailText.text = ""
        passwordText.text = ""
    }
    
}

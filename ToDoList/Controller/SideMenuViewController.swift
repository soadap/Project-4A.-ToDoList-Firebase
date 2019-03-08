//
//  SideMenuViewController.swift
//  ToDoList
//
//  Created by soadap on 2/9/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            showMessage(signOutError.description, self)
            return()
        }
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: LOGIN_STORYBOARD)
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    


}

//
//  Const.swift
//  ToDoList
//
//  Created by soadap on 1/31/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let CELL_IDENTIFIER = "ToDoCellIdentifier"
let SAVE_UNWIND_SEGUE = "saveUnwind"
let SHOW_DETAILS_SEGUE = "showDetails"
let LOGIN_SUCCESS_SEGUE = "loginSucess"
let MAIN_VIEW_STORYBOARD = "MainView"
let LOGIN_STORYBOARD = "LoginStoryboard"

func showMessage(_ errorDescription: String?, _ view: UIViewController) {
    let alert = UIAlertController(title: "Message", message: errorDescription, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(okButton)
    view.present(alert, animated: true, completion: nil)
}

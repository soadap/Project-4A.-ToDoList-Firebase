//
//  Database.swift
//  ToDoList
//
//  Created by soadap on 2/9/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import Foundation
import Firebase

class Service {
    static let shared = Service()

    static var downloadedTodo = [ToDo]()    
    let db = Firestore.firestore()
    
    static func addToDoFirebase(_ todo: ToDo) -> String? {
        return Service.shared.db.collection("\(Auth.auth().currentUser!.email!)").addDocument(data: [
            "title" : todo.title,
            "isCompleted" : todo.isComplete,
            "dueDate" : todo.dueDate,
            "notes" : todo.notes!
            ]).documentID
    }
    
    static func updateToDoFirebase(_ todo: ToDo) {
        Service.shared.db.collection("\(Auth.auth().currentUser!.email!)").document(todo.documentID!).setData(([
            "title" : todo.title,
            "isCompleted" : todo.isComplete,
            "dueDate" : todo.dueDate,
            "notes" : todo.notes!
            ]))
    }
    
    static func downloadToDoFromFirebase(_ controller: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        Service.shared.db.collection("\(Auth.auth().currentUser!.email!)").getDocuments { (querySnapshot, err) in
            if let err = err {
                showMessage(err.localizedDescription, controller)
                return
            } else {
                Service.downloadedTodo = querySnapshot!.documents.map { (document) -> ToDo in
                    var todo = ToDo(dictionary: document.data())
                    todo.documentID = document.documentID
                    return todo
                }
                completionHandler(true)
            }
        }
    }
    
    static func deleteFromFirebase(_ todo: ToDo) {
        if let docID = todo.documentID {
            Service.shared.db.collection("\(Auth.auth().currentUser!.email!)").document(docID).delete()
        }
    }
    
    
    static func autorizeFirebase(username: String, password: String, controller: UIViewController) {
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if error != nil {
                showMessage(error?.localizedDescription, controller)
            } else {
                controller.performSegue(withIdentifier: LOGIN_SUCCESS_SEGUE, sender: controller)
            }
        }
    }
    
    static func createUserFirebase(username: String, password: String, controller: UIViewController) {
        Auth.auth().createUser(withEmail: username, password: password) { (user, error) in
            if error != nil {
                showMessage(error?.localizedDescription, controller)
            } else {
                Service.autorizeFirebase(username: username, password: password, controller: controller)
            }
        }
    }

}


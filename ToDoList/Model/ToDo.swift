//
//  ToDo.swift
//  ToDoList
//
//  Created by soadap on 1/31/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import Foundation
import Firebase

struct ToDo : Codable {
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")

    var title : String
    var isComplete : Bool
    var dueDate : Date
    var notes : String?
    var documentID : String?
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.documentID = ""
    }
    
    init(dictionary : [String : Any]) {
        self.title = dictionary["title"] as! String
        self.isComplete = dictionary["isCompleted"] as! Bool
        self.notes = dictionary["notes"] as! String?
        let dDate = dictionary["dueDate"] as! Timestamp
        self.dueDate = dDate.dateValue()
    }
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func saveToDos(_ todos : [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
        
        
    }
    
    static func loadSampleToDo() -> [ToDo] {
        let toDo1 = ToDo(title: "Todo 1", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let toDo2 = ToDo(title: "Todo 2", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let toDo3 = ToDo(title: "Todo 3", isComplete: false, dueDate: Date(), notes: "Notes 3")
        return [toDo1, toDo2, toDo3]
    }
    
    
    static let dueDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var dictionary: [String: Any] {
        return [
            "title" : self.title,
            "isComplete" : self.isComplete,
            "notes" : self.notes,
            "dueDate" : self.dueDate
        ]
    }
}

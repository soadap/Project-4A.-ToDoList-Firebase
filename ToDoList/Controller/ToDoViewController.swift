//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by soadap on 1/31/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import UIKit
import MessageUI

class ToDoViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var titleTextField : UITextField!
    @IBOutlet weak var isCompleteButton : UIButton!
    @IBOutlet weak var dueDateLabel : UILabel!
    @IBOutlet weak var dueDatePicker : UIDatePicker!
    @IBOutlet weak var notesTextView : UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    
    var isDatePickerHidden = true
    var todo : ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePicker.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePicker.date = Date().addingTimeInterval(24*60*60)
        }
        
        updateDueDateLabel(date: dueDatePicker.date)
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        switch indexPath {
        case [0,1]:
            return isDatePickerHidden ? normalCellHeight : largeCellHeight
        case [1,0]:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,1]:
            isDatePickerHidden = !isDatePickerHidden
            dueDateLabel.textColor = isDatePickerHidden ? UIColor.black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        updateDueDateLabel(date: dueDatePicker.date)
    }
    
    @IBAction func textEditChanges(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        shareButton.isEnabled = !text.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let title = titleTextField.text!
        let isComlete = isCompleteButton.isSelected
        let dueDate = dueDatePicker.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComlete,  dueDate: dueDate, notes: notes)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        sendMail()
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            var mailContent = ("<p>\(titleTextField.text!)<p>")
            mailContent += isCompleteButton.isSelected ? ("<p>Completed!<p>") : ("<p>Not completed!<p>")
            mailContent += ("<p>Due date:<br>\(ToDo.dueDateFormatter.string(from: dueDatePicker.date))<p>")
            if notesTextView.text != "" {
                mailContent += ("<p>Notes:<br>\(notesTextView.text!)<p>")
            }
            mail.setMessageBody(mailContent, isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("Can't send a message.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
}

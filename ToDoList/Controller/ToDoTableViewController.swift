//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by soadap on 1/31/19.
//  Copyright © 2019 soadap. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    var todos = [ToDo]()
    var filteredTodos = [ToDo]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            Service.updateToDoFirebase(todos[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
            updateUI()
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == SAVE_UNWIND_SEGUE else { return }
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let todoID = todos[selectedIndexPath.row].documentID
                todos[selectedIndexPath.row] = todo
                todos[selectedIndexPath.row].documentID = todoID
                Service.updateToDoFirebase(todos[selectedIndexPath.row])
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                todos[newIndexPath.row].documentID = Service.addToDoFirebase(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDo()
        }
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        Service.downloadToDoFromFirebase(self) { (downloaded) in
            if downloaded {
                self.updateDownloadedTodos()
            }
        }
    }
    
    
    func updateDownloadedTodos() {
        todos = Service.downloadedTodo
        updateUI()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isFiltering() ? todos.count : filteredTodos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoTable = !isFiltering() ? todos : filteredTodos
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? ToDoCell else {
            fatalError("Could not degueue a cell.")
        }
        let todo = todoTable[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && !isFiltering() {
            Service.deleteFromFirebase(todos[indexPath.row])
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SHOW_DETAILS_SEGUE {
            let todoViewController = segue.destination as? ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = !isFiltering() ? todos[indexPath.row] : filteredTodos[indexPath.row]
            todoViewController?.todo = selectedTodo
            
        }
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filteredContentForSearch(_ searchText: String, scope: String = "All") {
        filteredTodos = todos.filter({ (todo: ToDo) -> Bool in
            return todo.title.lowercased().contains(searchText.lowercased())
        })
        updateUI()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateUI() {
        todos.sort()
        filteredTodos.sort()
        tableView.reloadData()
    }
}

extension ToDoTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearch(searchController.searchBar.text!)
    }
}

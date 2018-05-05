//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by M.D. Bijkerk on 03-05-18.
//  Copyright © 2018 M.D. Bijkerk. All rights reserved.
//


import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    // create the array with toDos
    var todos = [ToDo]()
    
    // try to load items from disk. If there are'nt any, load some sample data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // enable editing mode
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
    }
    
    // there should be one table view cell for each entry in todo
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    //dequeue a standard UITableViewCell, and set its titleLabel text to the title property of the corresponding ToDo.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // conditionally downcast this cell to your custom class so that it matches the type of cell defined in the storyboard
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
                    fatalError("Could not dequeue a cell")
                }
        
            cell.delegate = self
        
            let todo = todos[indexPath.row]
            cell.titleLabel?.text = todo.title
            cell.isCompleteButton.isSelected = todo.isComplete
            return cell
    }
    
    // state that each cell is editable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // when delete button is triggered, delete selected model from the ToDo array
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    // push from the list to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    // unwind method
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        ToDo.saveToDos(todos)
    }
    
    // execute when the check mark is tapped 
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
}

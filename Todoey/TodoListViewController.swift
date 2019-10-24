//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Kremski on 30/09/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import Toaster

class TodoListViewController: SwipeTableViewController {

    private var taskManager: TaskManager?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : CategoryEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskManager = TaskManager()
        taskManager!.delegate = self
        
        if let category = selectedCategory {
            taskManager?.loadTasks(categoryName: category.name)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskCount = taskManager!.tasksCount
        
        if (taskCount == 0 && searchBar.text == "") {
            return 1
        } else {
            return taskCount
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let taskCount = taskManager!.tasksCount
        
        if taskCount == 0 && searchBar.text == "" {
            cell.textLabel?.text = "No Tasks Added Yet"
            cell.accessoryType = .none
        } else if let task = taskManager?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
            cell.textLabel?.textColor = .white
            let categoryColorInHex = selectedCategory!.colorInHex
            let backgroundColor = UIColor(categoryColorInHex).darker(by: CGFloat(CGFloat(indexPath.row) / CGFloat(taskCount + 10)) * CGFloat(100))
            cell.backgroundColor = backgroundColor
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = taskManager?[indexPath.row] {
            item.done = !item.done
            tableView.deselectRow(at: indexPath, animated: true)
            self.taskManager?.updateTask(task: item)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = TaskEntity(title: textField.text!, colorInHex: "#FFFFFF", done: false)
            self.taskManager?.saveTask(task: newItem)
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    override func deleteCell(cellNumber: Int) {
        taskManager?.removeTask(at: cellNumber)
    }
}

//MARK: - TaskManagerDelegate methods
extension TodoListViewController : TaskManagerDelegate {
    func onTasksLoaded(tasks: [TaskEntity]) {
        self.tableView.reloadData()
    }
    
    func onTasksLoadingError(error: Error) {
        Toast(text: "Could not load tasks").show()
    }
    
    func onTaskSaved(task: TaskEntity) {
        Toast(text: "Task saved!").show()
        self.tableView.reloadData()
    }
    
    func onTaskSaveError(error: Error) {
        Toast(text: "Could not save task").show()
    }
    
    func onTaskRemoved(removedTask: TaskEntity) {
        Toast(text: "Task removed!").show()
        self.tableView.reloadData()
    }
    
    func onTaskRemovalError(error: Error) {
        Toast(text: "Could not remove task").show()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            taskManager?.search(for: "")
            tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            taskManager?.search(for: searchBar.text!)
            tableView.reloadData()
        }
    }
}

//MARK: - Color extension
extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

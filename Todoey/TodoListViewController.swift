//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Kremski on 30/09/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    private var tasks : Results<TaskEntity>?
    
    private var originalBarTintColor: UIColor?
    private var originalTintColor: UIColor?
    private var originalLargeTitleTextAttributes: [NSAttributedString.Key : Any]?
    
    var selectedCategory : CategoryEntity? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorInHex = selectedCategory?.colorInHex else { fatalError() }
        guard let navigationBar = navigationController?.navigationBar else { fatalError() }
        
        let categoryColor = UIColor(hexString: colorInHex)!
        let contractColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        title = selectedCategory!.name
        
        originalBarTintColor = navigationBar.barTintColor
        navigationBar.barTintColor = categoryColor
        
        originalTintColor = navigationBar.tintColor
        navigationBar.tintColor = contractColor
        
        originalLargeTitleTextAttributes = navigationBar.largeTitleTextAttributes
        navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : contractColor]
        
        searchBar.barTintColor = categoryColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = originalBarTintColor
        navigationController?.navigationBar.tintColor = originalTintColor
        navigationController?.navigationBar.largeTitleTextAttributes = originalLargeTitleTextAttributes
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tasks?.count == 0 && searchBar.text == "") {
            return 1
        } else {
            return tasks?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if tasks?.count == 0 && searchBar.text == "" {
            cell.textLabel?.text = "No Tasks Added Yet"
            cell.accessoryType = .none
        } else if let task = tasks?[indexPath.row], let count = tasks?.count{
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
            
            let categoryColorInHex = selectedCategory!.colorInHex
            let backgroundColor = UIColor(hexString: categoryColorInHex)!.darken(byPercentage: CGFloat(CGFloat(indexPath.row) / CGFloat(count + 10)))!
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = tasks?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let category = self.selectedCategory {
                let newItem = TaskEntity()
                newItem.done = false
                newItem.title = textField.text!
                newItem.createdDate = Date()
                newItem.colorInHex = UIColor.randomFlat.hexValue()
                
                do {
                    try self.realm.write {
                        category.tasks.append(newItem)
                    }
                    
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    private func loadItems() {
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "createdDate", ascending: false)
        
        tableView.reloadData()
    }
    
    override func deleteCell(cellNumber: Int) {
        if let category = selectedCategory {
            do {
                try self.realm.write {
                    category.tasks.remove(at: cellNumber)
                }
            } catch {
                print(error)
            }
        } else {
            fatalError("Could not delete cell")
        }
    }
}


//MARK: - Saerch bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: false)
            tableView.reloadData()
        }
    }
}

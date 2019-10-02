//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories : Results<CategoryEntity>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    private func loadItems() {
        categories = realm.objects(CategoryEntity.self)
        tableView.reloadData()
    }
    
    private func save(category: CategoryEntity) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func deleteCell(cellNumber: Int) {
        if let categoryToDelete = self.categories?[cellNumber] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print(error)
            }
        } else {
            fatalError("Could not delete cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (categories?.count == 0) {
            return 1
        } else {
            return categories?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if categories?.count == 0 {
            cell.textLabel?.text = "No Categories Added Yet"
        } else if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.colorInHex)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.colorInHex)!, returnFlat: true)
        }
        
        return cell
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Caregory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = CategoryEntity()
            newCategory.name = textField.text!
            newCategory.colorInHex = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToItems") {
            let controller = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    //MARK: - TablewView Delegate Methods
}

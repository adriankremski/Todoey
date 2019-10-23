//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit
import Firebase
import UIColor_Hex_Swift
import Toaster

class CategoryViewController: SwipeTableViewController {

    var categoryManager : CategoryManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryManager = CategoryManager()
        categoryManager?.delegate = self
        categoryManager?.loadCategories()
    }
    
    override func deleteCell(cellNumber: Int) {
        categoryManager?.removeCategory(at: cellNumber)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryManager!.categoriesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if categoryManager?.categoriesCount == 0 {
            cell.textLabel?.text = "No Categories Added Yet"
        } else if let category = categoryManager?[indexPath.row] {
            cell.textLabel?.text = category.name
            let backgroundColor = UIColor(category.colorInHex)
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = UIColor.white
        }

        return cell
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Caregory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = CategoryEntity(
                name: textField.text!,
                colorInHex: "#E74C3C"
            )
            
            self.categoryManager?.save(category)
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
                controller.selectedCategory = categoryManager?[indexPath.row]
            }
        }
    }
}

//MARK: - CategoryManagerDelegate methods
extension CategoryViewController : CategoryManagerDelegate {
    
    func onCategoriesLoadingError(error: Error) {
        Toast(text: "Could not load categories").show()
    }
    
    func onCategoriesLoaded(categories: [CategoryEntity]) {
        self.tableView.reloadData()
    }
    
    func onCategoryRemovalError(error: Error) {
        Toast(text: "Could not remove category").show()
    }
    
    func onCategoryRemoved(removedCategory: CategoryEntity) {
        Toast(text: "Category removed!").show()
        self.tableView.reloadData()
    }
    
    func onCategorySaved(category: CategoryEntity) {
        Toast(text: "Category saved!").show()
        self.tableView.reloadData()
    }
    
    func onCategorySaveError(error: Error) {
        Toast(text: "Could not save category").show()
    }
}

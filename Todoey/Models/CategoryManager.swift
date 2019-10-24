//
//  CategoryManager.swift
//  Todoey
//
//  Created by Adrian Kremski on 22/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CategoryManager {
    private var categories : [CategoryEntity]?
    private var categoriesReference: CollectionReference!
    var delegate: CategoryManagerDelegate?
    
    var categoriesCount: Int {
        categories?.count ?? 0
    }
    
    subscript(categoryPosition: Int) -> CategoryEntity? {
        categories?[categoryPosition]
    }
    
    init() {
        categoriesReference = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("categories")
    }
    
    func loadCategories() {
        categoriesReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                self.delegate?.onCategoriesLoadingError(error: error)
            } else {
                self.categories = querySnapshot!.documents.map { (document) -> CategoryEntity in
                    return CategoryEntity(fields: document.data())
                }
                
                self.delegate?.onCategoriesLoaded(categories: self.categories!)
            }
        }
    }
    
    func save(_ category: CategoryEntity) {
        self.categoriesReference.document(category.name).setData(category.fields) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
                self.delegate?.onCategorySaveError(error: error)
            } else {
                print("Category successfully written!")
                self.categories?.append(category)
                self.delegate?.onCategorySaved(category: category)
            }
        }
    }
    
    func removeCategory(at categoryPosition: Int) {
        if let safeCategories = categories, categoryPosition < safeCategories.count {
            let categoryToRemove = safeCategories[categoryPosition]
            
            categoriesReference.document(categoryToRemove.name).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error)")
                    self.delegate?.onCategoryRemovalError(error: error)
                } else {
                    self.categories!.remove(at: categoryPosition)
                    self.delegate?.onCategoryRemoved(removedCategory: categoryToRemove)
                }
            }
        }
    }
}

protocol CategoryManagerDelegate {
    func onCategoriesLoaded(categories : [CategoryEntity])
    func onCategoriesLoadingError(error: Error)
    
    func onCategoryRemoved(removedCategory: CategoryEntity)
    func onCategoryRemovalError(error: Error)
    
    func onCategorySaved(category: CategoryEntity)
    func onCategorySaveError(error: Error)
}

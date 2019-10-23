//
//  TaskManager.swift
//  Todoey
//
//  Created by Adrian Kremski on 22/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import FirebaseFirestore

class TaskManager {
    private var tasks : [TaskEntity]?
    private var tasksReference: CollectionReference!
    var delegate: TaskManagerDelegate?
    
    var tasksCount: Int {
        tasks?.count ?? 0
    }
    
    subscript(position: Int) -> TaskEntity? {
        tasks?[position]
    }
    
    func loadTasks(categoryName: String) {
        tasksReference = Firestore.firestore().collection("categories").document(categoryName).collection("tasks")
        
        tasksReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting tasks: \(error)")
                self.delegate?.onTasksLoadingError(error: error)
            } else {
                self.tasks = querySnapshot!.documents.map { (document) -> TaskEntity in
                    return TaskEntity(fields: document.data())
                }
                
                self.delegate?.onTasksLoaded(tasks: self.tasks!)
            }
        }
    }
    
    func search(for query: String) {
//        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: false)
        //            tableView.reloadData()
    }
    
    func saveTask(task: TaskEntity) {
        tasksReference.document(task.title).setData(task.fields) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
                self.delegate?.onTaskSaveError(error: error)
            } else {
                print("Task successfully written!")
                self.tasks?.append(task)
                self.delegate?.onTaskSaved(task: task)
            }
        }
    }
    
    func removeTask(at position: Int) {
        if let safeTasks  = tasks, position < safeTasks.count {
            let taskToRemove = safeTasks[position]
            
            tasksReference.document(taskToRemove.title).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error)")
                    self.delegate?.onTaskRemovalError(error: error)
                } else {
                    self.tasks!.remove(at: position)
                    self.delegate?.onTaskRemoved(removedTask: taskToRemove)
                }
            }
        }
    }
}

protocol TaskManagerDelegate {
    func onTasksLoaded(tasks : [TaskEntity])
    func onTasksLoadingError(error: Error)
    
    func onTaskRemoved(removedTask: TaskEntity)
    func onTaskRemovalError(error: Error)
    
    func onTaskSaved(task: TaskEntity)
    func onTaskSaveError(error: Error)
}

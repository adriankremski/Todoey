//
//  TaskEntity.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import RealmSwift

class TaskEntity  {
    var title: String = ""
    var done: Bool = false
//    var createdDate: Date?
    var colorInHex: String = ""
//    var parentCategory = LinkingObjects(fromType: CategoryEntity.self, property: "tasks")
    
    var fields : [String : Any] {
        [ "title": title, "colorInHex": colorInHex, "done": done]
    }
    
    init(title: String, colorInHex: String, done: Bool) {
        self.title = title
        self.colorInHex = colorInHex
        self.done = done
    }
    
    init(fields : [String : Any] ) {
        self.title = fields["title"] as! String
        self.colorInHex = fields["colorInHex"] as! String
        self.done = fields["done"] as! Bool
    }
}

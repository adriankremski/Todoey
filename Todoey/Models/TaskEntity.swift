//
//  TaskEntity.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import RealmSwift

class TaskEntity: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    @objc dynamic var colorInHex: String = ""
    var parentCategory = LinkingObjects(fromType: CategoryEntity.self, property: "tasks")
}

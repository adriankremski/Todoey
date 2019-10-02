//
//  Data.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}


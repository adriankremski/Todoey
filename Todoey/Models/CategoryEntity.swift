//
//  CategoryEntity.swift
//  Todoey
//
//  Created by Adrian Kremski on 01/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation

struct CategoryEntity {
    let name: String
    let colorInHex: String
    
    var fields : [String : Any] {
        [ "name": name, "colorInHex": colorInHex]
    }
    
    init(name: String, colorInHex: String) {
        self.name = name
        self.colorInHex = colorInHex
    }
    
    init(fields : [String : Any] ) {
        self.name = fields["name"] as! String
        self.colorInHex = fields["colorInHex"] as! String
    }
}

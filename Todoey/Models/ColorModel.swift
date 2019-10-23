//
//  ColorModel.swift
//  Todoey
//
//  Created by Adrian Kremski on 21/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation

class ColorsSource {

    let colors = [
        "#1abc9c", "#2ecc71", "#3498db"
    ]
    
    func randomColorInHex() -> String {
        return colors.randomElement()!
    }
}

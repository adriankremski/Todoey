//
//  ColorsSource.swift
//  Todoey
//
//  Created by Adrian Kremski on 21/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import Foundation
import UIKit

class ColorsSource {

    let colors = [
        "#E74C3C"
    ]

    func randomColorInHex() -> String {
        return colors.randomElement()!
    }
}

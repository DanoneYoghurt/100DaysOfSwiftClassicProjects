//
//  Person.swift
//  project10
//
//  Created by Антон Баскаков on 30.08.2024.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

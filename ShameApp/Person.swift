//
//  Person.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation

class Person {
    var id: Int
    var name: String
    var photo: String
    var shame: String
    
    init(id: String, name: String, photo: String, shame: String) {
        self.id = Int(id)!
        self.name = name
        self.photo = photo
        self.shame = shame
    }
}

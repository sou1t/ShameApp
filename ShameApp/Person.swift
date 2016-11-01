//
//  Person.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import VK_ios_sdk
import SwiftyJSON

class Person {
    var id: Int
    var name: String
    var surname: String
    var photo: String
    
    init(id: String, name: String, surname:String, photo: String) {
        self.id = Int(id)!
        self.name = name
        self.surname = surname
        self.photo = photo
    }
}

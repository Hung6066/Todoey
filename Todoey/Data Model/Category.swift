//
//  Category.swift
//  Todoey
//
//  Created by HUNG-PC on 7/18/18.
//  Copyright © 2018 HUNG-PC. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}

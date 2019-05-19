//
//  Category.swift
//  ToDoApp
//
//  Created by Vladislav on 06/05/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let tasks = List<Task>()
}


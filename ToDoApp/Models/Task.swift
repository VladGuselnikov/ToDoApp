//
//  Task.swift
//  ToDoApp
//
//  Created by Vladislav on 06/05/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdAt: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}

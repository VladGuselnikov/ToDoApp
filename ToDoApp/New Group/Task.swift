//
//  Task.swift
//  ToDoApp
//
//  Created by Vladislav on 16/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import Foundation

class Task :Codable {
    var title:String?
    var done = false
    
    init(title: String) {
        self.title = title
    }
}

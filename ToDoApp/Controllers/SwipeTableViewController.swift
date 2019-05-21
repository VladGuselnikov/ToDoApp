//
//  SwipeTableViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 19/05/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIScreen.main.scale)
        tableView.rowHeight = 80

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let swipeAction = SwipeAction(style: .default, title: "Delete"){
            (action, path) in
            print(path.row)
            self.deleteRow(with: indexPath)
            }
        
        
        swipeAction.backgroundColor = .red
        swipeAction.image = UIImage(named: "Trash Icon")
        return [swipeAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteRow(with indexPath: IndexPath) {
    }
}

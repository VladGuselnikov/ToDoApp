//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    let itemsToDo = ["rereg","ergregrr","fffffff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = itemsToDo[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDo.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myCell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        myCell?.textLabel?.text = String(Int.random(in: 0...5))
        if myCell?.accessoryType == .checkmark{
            myCell?.accessoryType = .none
        }
        else{
            myCell?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


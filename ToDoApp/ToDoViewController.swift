//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var toDoArray = ["rereg","ergregrr","fffffff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
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

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        let alertAction = UIAlertAction(title: "Add", style: .default, handler: {
            (result) in
            if let textFieldValue = alert.textFields![0].text{
                self.toDoArray.append(textFieldValue)
                self.tableView.reloadData()
            }
        })
        
        alert.addAction(alertAction)
        present(alert,animated: true)
    }
}


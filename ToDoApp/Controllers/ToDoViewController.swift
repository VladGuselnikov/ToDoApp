//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var toDoArray:[Task] = [Task(title: "Test task")]
    
    let defaultsArrayKey = "ToDoArray"
    
    var defaultsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultsPath = defaultsPath?.appendingPathComponent("\(defaultsArrayKey).plist")
        print(defaultsPath!)
        //Taking of data from local memory
        loadTasks()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let task = toDoArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveTasks()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New task", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        let alertAction = UIAlertAction(title: "Add", style: .default, handler: {
            (result) in
            if let textFieldValue = alert.textFields?.first?.text{
                if textFieldValue != ""{
                    self.toDoArray.append(Task(title: textFieldValue))
                    self.tableView.reloadData()
                    self.saveTasks()
                }
                
            }
        })
        
        alert.addAction(alertAction)
        present(alert,animated: true)
    }
    
    func saveTasks() {
        let plEncoder = PropertyListEncoder()
        do {
            
            let data = try plEncoder.encode(toDoArray)
            try data.write(to: defaultsPath!)
        } catch {
            print("Encoding error",error)
        }
    }
    
    func loadTasks() {
        let plDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: defaultsPath!) {
            do{
                toDoArray = try plDecoder.decode([Task].self, from: data)

            }catch{
                print("Decoding error",error)
            }
            
        }
    }
}


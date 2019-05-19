//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    
    
    @IBOutlet var taskSearchBar: UISearchBar!
    
    var tasks: Results<Task>?
    var categoryPredicate: NSPredicate?
    
    var currentCategory: Category?{
        didSet{
            loadTasks()
        }
    }
    
    let realm = try! Realm()
    
    let defaultsArrayKey = "ToDoArray"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
               // Do any additional setup after loading the view.
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let task = tasks?[indexPath.row]
        cell.textLabel?.text = task!.title
        cell.accessoryType = task!.done ? .checkmark : .none
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        update(task: (tasks?[indexPath.row])!)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
                    let newTask = Task()
                    newTask.title = textFieldValue
                    newTask.createdAt = Date()
                    self.save(task: newTask)
                }
                
            }
        })
        
        alert.addAction(alertAction)
        present(alert,animated: true)
    }
    
    func save(task: Task) {
        do {
            try realm.write {
                currentCategory?.tasks.append(task)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()

    }
    
    func update(task: Task) {
        do {
            try realm.write {
                task.done = !task.done
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()
        
    }
    
   
    
    func loadTasks() {
        tasks = currentCategory?.tasks.sorted(byKeyPath: "createdAt", ascending: true)
    }
}

extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tasks = currentCategory?.tasks.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadTasks()
            tableView.reloadData()

        }
    }
}

//extension ToDoViewController : ChooseCategory{
//    func userChoosed(category: Category) {
//        currentCategory = category
//        print(category.name!)
//        loadTasks()
//    }
//
//
//}
//
//protocol ChooseCategory {
//    func userChoosed(category: Category)
//}



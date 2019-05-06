//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    
    
    @IBOutlet var taskSearchBar: UISearchBar!
    
    var toDoArray:[Task] = []
    var currentCategory: Category?{
        didSet{
            loadTasks()
        }
    }
    
    let defaultsArrayKey = "ToDoArray"
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
        
//        loadTasks()
        
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
//        context.delete(toDoArray[indexPath.row])
//        toDoArray.remove(at: indexPath.row)
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
                    let task = Task(context: self.context)
                    task.title = textFieldValue
                    task.parentCategory = self.currentCategory
                    self.toDoArray.append(task)
                    self.tableView.reloadData()
                    self.saveTasks()
                }
                
            }
        })
        
        alert.addAction(alertAction)
        present(alert,animated: true)
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Context save error",error)
        }
    }
    
    func loadTasks(with request : NSFetchRequest<Task> = Task.fetchRequest()) {
        let categoryPredicate = NSPredicate(format: "parentCategory = %@", currentCategory!)
        if request.predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!,categoryPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do {
            toDoArray = try context.fetch(request)
        } catch {
            print("Context read error")
        }

        tableView.reloadData()
    }
    
}

extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let searchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            searchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadTasks(with: searchRequest)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadTasks()
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


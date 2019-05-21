//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 15/04/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeTableViewController {
    
    
    
    @IBOutlet var taskSearchBar: UISearchBar!
    @IBOutlet var searchBar: UISearchBar!
    
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
        tableView.separatorStyle = .none
        
               // Do any additional setup after loading the view.
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        title = currentCategory?.name
        guard let categoryColor = currentCategory?.color else {fatalError()}
        updateSearchBar(with: categoryColor)
        updateNavBar(with: categoryColor)
    }

    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(with: "128797")
    }
    
    func updateNavBar(with hexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("no navigationController")}
        if let navBarColor = UIColor(hexString: hexCode) {
            navBar.barTintColor = navBarColor
             navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        }
    }
    
    func updateSearchBar(with hexCode: String) {
        if let searchBarColor = UIColor(hexString: hexCode) {
            searchBar.barTintColor = searchBarColor
//            searchBar.layer.borderWidth = 1
//            searchBar.layer.borderColor = searchBarColor.cgColor
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let task = tasks?[indexPath.row]
        cell.textLabel?.text = task!.title
        cell.accessoryType = task!.done ? .checkmark : .none
        let flatColor = UIColor(hexString: currentCategory!.color)
        if let cellColor = flatColor!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(tasks!.count)) {
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        update(task: (tasks?[indexPath.row])!)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func deleteRow(with indexPath: IndexPath) {
        if let swipeTask = tasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(swipeTask)
                }
            } catch {
                print(error)
            }
        }
        
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



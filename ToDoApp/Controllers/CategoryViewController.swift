//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Vladislav on 02/05/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    

    var categories : Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadCategories()
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCategoryTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoryTasks" {
            let toDoViewController = segue.destination as! ToDoViewController
            toDoViewController.currentCategory = categories?[tableView.indexPathForSelectedRow!.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Category"
            })
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let categoryName = alert.textFields?.first?.text{
                if categoryName != ""{
                    let newCategory = Category()
                    newCategory.name = categoryName
                    self.save(category: newCategory)
                }
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()

    }
}




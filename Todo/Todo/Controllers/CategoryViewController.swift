//
//  CategoryViewController.swift
//  Todo
//
//  Created by Abhishek Kumar on 16/02/19.
//  Copyright © 2019 Apbcptech. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Show popup with add item.
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { [unowned self](action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoriesArray.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated:false , completion: nil)
    }
    
    func loadCategories(){
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print("Error in fetching categories \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving contex \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
}

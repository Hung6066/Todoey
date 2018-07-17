//
//  ViewController.swift
//  Todoey
//
//  Created by HUNG-PC on 7/16/18.
//  Copyright © 2018 HUNG-PC. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    
    let defaults = UserDefaults.standard
    
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
      let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
   
//        print(dataFilePath)

//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Buy Eggos"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Destroy Demogorgon"
//        itemArray.append(newItem2)
        
        loadItems()
        print(dataFilePath)

    }
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        //Ternary operator ===>
        //Value == condition ?  true : false
        
        cell.accessoryType = item.done == true ? .checkmark : .none
    
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(intArray[indexPath.row])
        
       
        
//        context.delete(itemArray[indexPath.row])
//         itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       
        
         var textField = UITextField()
        
       
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
           
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")

             let newItem = Item(context: self.context)
             newItem.title = textField.text!
             newItem.done = false
             self.itemArray.append(newItem)
            self.saveItems()
        }
            
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    

    }
    
    
    func saveItems() {
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \n")
        }
        
        self.tableView.reloadData()
        }

    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
        
    }

}


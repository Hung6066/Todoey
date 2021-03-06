//
//  ViewController.swift
//  Todoey
//
//  Created by HUNG-PC on 7/16/18.
//  Copyright © 2018 HUNG-PC. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let defaults = UserDefaults.standard
    
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//      let context = (UIApplication.shared.delegate as! AppDelegate)
//        .persistentContainer.viewContext

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
        
       
        
        
        print(dataFilePath ?? "")

    }
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        
        //Ternary operator ===>
        //Value == condition ?  true : false
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(intArray[indexPath.row])
        
        
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
//                realm.delete(item)
                item.done = !item.done
            }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
       
        
//        context.delete(itemArray[indexPath.row])
//         itemArray.remove(at: indexPath.row)
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//
//        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       
        
         var textField = UITextField()
        
       
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in

//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                   
                   
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                   }
                } catch {
                    print("Error saving new items, \(error)")
                }
             
            }
            

             self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    

    }
    
    
    func saveItems() {
        
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \n")
//        }
//
        self.tableView.reloadData()
        }

    func loadItems(){
        
       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
   

}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//
//       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate: predicate)


    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
                
            }

        }
        
        
    }
    
}


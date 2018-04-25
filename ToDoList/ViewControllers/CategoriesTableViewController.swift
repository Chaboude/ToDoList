//
//  CategoriesTableViewController.swift
//  ToDoList
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    let formatter = DateFormatter()
    
    
    
    var categories = [Category]()
    var selectedCategoty: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.loadCategory()
        categories = DataManager.sharedInstance.cachedCategories

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func addAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DO IT ?", message: "Give this category a name !", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default){
            (action) in
            
            let textField = alertController.textFields![0]
            
            DataManager.sharedInstance.addCategory(text: textField.text!)
            
            self.tableView.reloadData()
            self.categories = DataManager.sharedInstance.cachedCategories
        }
        alertController.addTextField{(textfield) in
            textfield.placeholder = "Name"
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return DataManager.sharedInstance.cachedCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.detailTextLabel?.text = formatter.string(from:categories[indexPath.row].createdAt!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategoty = categories[indexPath.row]
        performSegue(withIdentifier: "FromCategoriesToItem", sender: nil)
    }
    
}

extension CategoriesTableViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromCategoriesToItem"{
            let destination = segue.destination as! ListViewController
            destination.category = self.selectedCategoty
        }
    }
}

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
     var dataManager: DataManager = DataManager.sharedInstance
    
    

    var selectedCategoty: Category?
    var alertController : UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.loadCategory()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func addAction(_ sender: Any) {
        
        alertController = UIAlertController(title: "DO IT ?", message: "Give this category a name !", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){
            (action) in
            
            let textField = self.alertController?.textFields![0]
            
            self.dataManager.addCategory(text: (textField?.text!)!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel )
        alertController?.addTextField{(textfield) in
            textfield.placeholder = "Name"
            textfield.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        okAction.isEnabled = false
        alertController?.addAction(okAction)
        alertController?.addAction(cancelAction)
        
        present(alertController!, animated: true, completion: nil)
        
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alertController?.actions[0].isEnabled = sender.text!.count > 0
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
        cell.textLabel?.text = dataManager.cachedCategories[indexPath.row].name
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.detailTextLabel?.text = formatter.string(from:dataManager.cachedCategories[indexPath.row].createdAt!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategoty = dataManager.cachedCategories[indexPath.row]
        performSegue(withIdentifier: "FromCategoriesToItem", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let category = dataManager.cachedCategories[indexPath.row]
        dataManager.delete(item: nil, category: category)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
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

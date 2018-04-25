
//
//  ViewController.swift
//  ToDoList
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var category: Category?
    var selectedItem: Item?
    var alertController : UIAlertController?
    
    var dataManager: DataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.getItemsForCategory(category!)
        
    }
    
    //MARK: Actions
    @IBAction func addAction(_ sender: Any) {
        
        alertController = UIAlertController(title: "DO IT ?", message: "You can do it", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){
            (action) in
            
            let textField = self.alertController?.textFields![0]
            
            self.dataManager.addItems(text: (textField?.text!)!, category: self.category)
            
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel )
        alertController?.addTextField{(textfield) in
            textfield.placeholder = "Name"
            textfield.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        okAction.isEnabled = false
        alertController?.addAction(cancelAction)
        alertController?.addAction(okAction)
        present(alertController!, animated: true, completion: nil)
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alertController?.actions[1].isEnabled = sender.text!.count > 0
    }
    
    
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.cachedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier") as! ListTableViewCell
        let item = dataManager.cachedItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.checkmarkLabel.isHidden = !item.checked
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataManager.cachedItems[indexPath.row]
        item.checked = !item.checked
        self.dataManager.saveItems()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataManager.cachedItems.count > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = dataManager.cachedItems[indexPath.row]
        dataManager.delete(item: item, category: category!)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            selectedItem = dataManager.cachedItems[indexPath.row]
            performSegue(withIdentifier: "FromItemToDetail", sender: nil)
    }
    
}

extension ListViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataManager.cachedItems = dataManager.filterItems(textToFind: searchText)
        tableView.reloadData()
    }
}

extension ListViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromItemToDetail"{
            let dest = segue.destination as! DetailViewController
            dest.item = selectedItem!
        }
    }
}


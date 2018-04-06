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
    
    var items2 = [Item]()
    
    var dataManager: DataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    func createitems(){
//        for item in items{
//            let newElement = Item(name: item)
//            items2.append(newElement)
//        }
//    }
    
    override func awakeFromNib() {
        dataManager.loadItems()
        items2 = dataManager.cachedItems
    }
    
    //MARK: Actions
    @IBAction func addAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DO IT ?", message: "You can do it", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default){
            (action) in
            
            let textField = alertController.textFields![0]
            
            self.dataManager.addItems(text: textField.text!)
            
            self.tableView.reloadData()
            self.items2 = self.dataManager.cachedItems
            self.searchBar.text = ""
            self.tableView.reloadData()
        }
        alertController.addTextField{(textfield) in
            textfield.placeholder = "Name"
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        //let buttonType: UIBarButtonItem = tableView.isEditing ? .done : .edit
        //navigationItem.setLeftBarButton(, animated: true)
    }
    
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier")
        let item = items2[indexPath.row]
        cell?.textLabel?.text = item.name
        cell?.accessoryType = item.checked ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = dataManager.cachedItems.remove(at: sourceIndexPath.row)
        let sourceItem2 = items2.remove(at: sourceIndexPath.row)
        dataManager.cachedItems.insert(sourceItem, at: destinationIndexPath.row)
        items2.insert(sourceItem2, at: destinationIndexPath.row)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items2[indexPath.row]
        item.checked = !item.checked
        self.dataManager.saveItems()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataManager.cachedItems.count > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let itemIndex = dataManager.cachedItems.index(where:{ $0 === items2[indexPath.item]})!
        items2.remove(at: indexPath.item)
        dataManager.delete(item: dataManager.cachedItems[itemIndex])
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

extension ListViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items2 = dataManager.filterItems(textToFind: searchText)
        tableView.reloadData()
    }
}


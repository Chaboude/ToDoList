//
//  DataManager.swift
//  ToDoList
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    var cachedItems: [Item]
    var cachedCategories: [Category]
    
    enum SortParam: String{
        case dateAsc = "createdAt"
        case dateDsc
        case alphabetic
        case none
    }
    

    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("CheckLists").appendingPathExtension("json")
    }
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static let sharedInstance = DataManager()
    private init(){
        cachedItems = []
        cachedCategories = []
    }

    func saveItems(){
        saveContext()
    }
    
    func addItems(text: String, category: Category? = nil){
        let item = Item(context: persistentContainer.viewContext)
        item.createdAt = Date()
        item.name = text
        item.checked = false
        item.category = category
        item.image?.data = UIImagePNGRepresentation(#imageLiteral(resourceName: "justdoit"))
        self.cachedItems.append(item)
        self.sort(byParams: .alphabetic,forElements: cachedItems)
        saveItems()
    }
    
    func addCategory(text: String){
        let category = Category(context: persistentContainer.viewContext)
        category.createdAt = Date()
        category.name = text
        self.cachedCategories.append(category)
        self.sort(byParams: .alphabetic,forElements: cachedCategories)
        saveItems()
    }
    
    func delete(item: Item? = nil, category: Category){
        if item != nil{
            context.delete(item!)
            saveItems()
            getItemsForCategory(category)
        }else{
            context.delete(category)
            saveItems()
            loadCategory()
        }
    }
    
    func loadCategory(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
           cachedCategories = try context.fetch(fetchRequest)
           self.sort(byParams: .alphabetic,forElements: cachedCategories)
        
        } catch {
            debugPrint("Could not noad the item from Core Data")
        }
    }
    
    func getItemsForCategory(_ category: Category)
    {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"category = %@", category)
        do{
            cachedItems = try context.fetch(fetchRequest)
            self.sort(byParams: .alphabetic,forElements: cachedItems)
        } catch {
            debugPrint("Could not noad the item from Core Data")
        }
    }
    
    
    
    func filterItems(textToFind: String) -> [Item]{
        
        var items: [Item]! = nil
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        if textToFind.count > 0 {
            let predicate = NSPredicate(format: "name contains[cd] %@", textToFind)
            fetchRequest.predicate = predicate
        }
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            debugPrint("Could not load items from Core Data")
        }
        
        return items
    }
    
    
    func sort(byParams params : SortParam = .none, forElements cachedData: Any){
        let sortDescriptors: NSSortDescriptor
        if let array = cachedData as? [Item]{
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            switch params {
            case .dateAsc:
                sortDescriptors = NSSortDescriptor(key: "createdAt", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .dateDsc:
                sortDescriptors = NSSortDescriptor(key: "createdAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .alphabetic:
                sortDescriptors = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .none:
                print("pas de tri")
            }
            do {
                cachedItems = try context.fetch(fetchRequest)
            } catch {
                debugPrint("Could not load items from Core Data")
            }
        }
        else if let array = cachedData as? [Category]{
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            switch params {
            case .dateAsc:
                sortDescriptors = NSSortDescriptor(key: "createdAt", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .dateDsc:
                sortDescriptors = NSSortDescriptor(key: "createdAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .alphabetic:
                sortDescriptors = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
                fetchRequest.sortDescriptors = [sortDescriptors]
            case .none:
                print("pas de tri")
            }
            do {
                cachedCategories = try context.fetch(fetchRequest)
            } catch {
                debugPrint("Could not load items from Core Data")
            }
        }
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

enum TypeToSort {
    case item
    case category
}

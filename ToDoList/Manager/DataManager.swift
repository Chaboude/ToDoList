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
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return documentDirectory.appendingPathComponent("CheckLists").appendingPathExtension("json")
    }
    
    static let sharedInstance = DataManager()
    private init(){
        cachedItems = []
    }

    func saveItems(){
        /*let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(cachedItems)
        try? data?.write(to: self.dataFileUrl)
        print(String(data: data!, encoding: .utf8)!)*/
        saveContext()
    }
    
    func addItems(text: String){
        let item = Item(context: persistentContainer.viewContext)
        item.name = text
        item.checked = false
        self.cachedItems.append(item)
        saveItems()
    }
    
    func loadItems(){
        /*let decoder = JSONDecoder()
        do{
            let stringJSON = try String(contentsOf: self.dataFileUrl, encoding: .utf8).data(using: .utf8)
            let data = try decoder.decode([Item].self, from:stringJSON!)
            self.cachedItems = data
        }
        catch{}*/
    }
    
    func filterItems(textToFind: String) -> [Item]{
        
        if(textToFind.isEmpty){
            return DataManager.sharedInstance.cachedItems
        }
        else{
            return self.cachedItems.filter{ $0.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(textToFind.lowercased()) }
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

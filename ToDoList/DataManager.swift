//
//  DataManager.swift
//  ToDoList
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

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
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(cachedItems)
        try? data?.write(to: self.dataFileUrl)
        print(String(data: data!, encoding: .utf8)!)
    }
    
    func loadItems(){
        let decoder = JSONDecoder()
        do{
            let stringJSON = try String(contentsOf: self.dataFileUrl, encoding: .utf8).data(using: .utf8)
            let data = try decoder.decode([Item].self, from:stringJSON!)
            self.cachedItems = data
        }
        catch{}
    }
    
    func filterItems(textToFind: String) -> [Item]{
        
        if(textToFind.isEmpty){
            return DataManager.sharedInstance.cachedItems
        }
        else{
            return self.cachedItems.filter{ $0.name.lowercased().contains(textToFind.lowercased()) }
        }
    }

}

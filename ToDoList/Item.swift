//
//  Item.swift
//  ToDoList
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class Item : Codable{
    var name: String
    var checked = false
    
    init(name: String){
        self.name = name
    }

}

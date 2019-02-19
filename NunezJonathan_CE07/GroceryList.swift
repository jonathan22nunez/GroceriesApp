//
//  GroceryList.swift
//  NunezJonathan_CE07
//
//  Created by Jonathan Nunez on 12/5/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation

class GroceryList {
    // Stored properties
    var listName: String = ""
    var itemsInList = [String]()
    var purchasedItems = [String]()
    
    // Computed properties
    var numberOfItemsInList: Int {
        return itemsInList.count
    }
    
    // Initializer
    init(listName: String, itemsInList: [String] = [String]()) {
        self.listName = listName
        self.itemsInList = itemsInList
    }
    
    // Optional initializer
    init?(jsonObject: [String: Any]) {
        guard let listName = jsonObject["listName"] as? String,
            let itemsInList = jsonObject["itemsInList"] as? [Any]
            else{return nil}
        
        self.listName = listName
        for item in itemsInList {
            guard let object = item as? String else{continue}
            self.itemsInList.append(object)
        }
    }
}

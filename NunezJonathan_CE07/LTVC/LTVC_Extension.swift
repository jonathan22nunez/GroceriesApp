//
//  LTVC_Extension.swift
//  NunezJonathan_CE07
//
//  Created by Jonathan Nunez on 12/5/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation

extension ListsTableViewController {
    
    func initializeDefaultGroceryLists() {
        // Build path to local .json file
        if let path = Bundle.main.path(forResource: "ShoppingLists", ofType: ".json") {
            // Create an URL with path
            let url = URL(fileURLWithPath: path)
            
            do {
                // Try to build Data buffer and de-serialize JSON
                let data = try Data.init(contentsOf: url)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                // Call JSON parsing method
                ParseJSON(jsonObject: jsonObj)
            }
            catch {
                print(error.localizedDescription)
            }
            // Reload tableview data
            tableView.reloadData()
        }
    }
    
    func ParseJSON(jsonObject: [Any]?) {
        guard let jsonObj = jsonObject else{return}
        
        // Iterate through JSON array
        for firstLevelItem in jsonObj {
            guard let object = firstLevelItem as? [String: Any]
                else{continue}
            
            // Add new grocery list objects to the empty array
            lists.append(GroceryList(jsonObject: object)!)
        }
    }
}

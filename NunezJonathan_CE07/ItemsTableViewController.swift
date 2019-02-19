//
//  ItemsTableViewController.swift
//  NunezJonathan_CE07
//
//  Created by Jonathan Nunez on 12/6/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    // MARK: Preparations
    var list: GroceryList!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title to the list name
        navigationItem.title = list.listName
        // Add a rightBarButton to the navigationBar, Add button that calls addTapped method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ItemsTableViewController.addTapped(_:)))
        // Register the xib to the tableviewcontroller
        tableView.register(UINib(nibName: "LTVC_SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "reuseSectionHeader")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Configure 2 sections in tableview
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each section will be based on the corresponding lists count using switch...case method
        var numberOfRows = 0
        switch section {
        case 0:
            numberOfRows += list.itemsInList.count
        case 1:
            numberOfRows += list.purchasedItems.count
        default:
            numberOfRows = 0
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = list.itemsInList[indexPath.row]
        case 1:
            cell.textLabel?.text = list.purchasedItems[indexPath.row]
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Set custom section header height to 75
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Set custom section header to that of sectionheaderviewcontroller
        let itemsNeededHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "reuseSectionHeader") as? LTVC_SectionHeaderViewController
        
        // Hide button in custom section header
        itemsNeededHeader?.headerButton.isHidden = true
        itemsNeededHeader?.numberOf_Label.text = "Number of Items:"
        // Update the header labels based on the section
        switch section {
        case 0:
            itemsNeededHeader?.sectionHeaderLabel.text = "Items Needed"
            itemsNeededHeader?.numberOfListsLabel.text = list.itemsInList.count.description
        case 1:
            itemsNeededHeader?.sectionHeaderLabel.text = "Purchased Items"
            itemsNeededHeader?.numberOfListsLabel.text = list.purchasedItems.count.description
        default:
            itemsNeededHeader?.sectionHeaderLabel.text = ""
            itemsNeededHeader?.numberOf_Label.text = ""
            itemsNeededHeader?.numberOfListsLabel.text = ""
        }
        
        return itemsNeededHeader
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Use switch...case to determine cell selection in it's section, add it to the other section, and finally remove it from its own section
        switch indexPath.section {
        case 0:
            list.purchasedItems.append(list.itemsInList[indexPath.row])
            list.itemsInList.remove(at: indexPath.row)
        case 1:
            list.itemsInList.append(list.purchasedItems[indexPath.row])
            list.purchasedItems.remove(at: indexPath.row)
        default:
            return
        }
        tableView.reloadData()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Alert for deletion of item in either section list
            let deleteItemAlert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            // Add delete button
            deleteItemAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
                let header = tableView.headerView(forSection: indexPath.section) as? LTVC_SectionHeaderViewController
                // Delete the row from the data source
                // Find the section and row for the cell
                // Remove from the tableview
                // Update the custom header label
                switch indexPath.section {
                case 0:
                    self.list.itemsInList.remove(at: indexPath.row)
                    let index = IndexPath(item: indexPath.row, section: indexPath.section)
                    tableView.deleteRows(at: [index], with: .left)
                    header?.numberOfListsLabel.text = self.list.itemsInList.count.description
                case 1:
                    self.list.purchasedItems.remove(at: indexPath.row)
                    let index = IndexPath(item: indexPath.row, section: indexPath.section)
                    tableView.deleteRows(at: [index], with: .left)
                    header?.numberOfListsLabel.text = self.list.purchasedItems.count.description
                default:
                    return
                }
                
            }))
            // Add cancel button
            deleteItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // Show alert
            self.present(deleteItemAlert, animated: true, completion: nil)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        // Build alert for add new item
        let addNewItemAlert = UIAlertController(title: "Add New Item", message: "Type the item below", preferredStyle: .alert)
        // Add a text field for user input
        addNewItemAlert.addTextField { (textField) in
            // Set placeholder
            textField.placeholder = "Enter item name"
        }
        // Add add button
        addNewItemAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alert) in
            // Get the textfield in own alert
            let textField = addNewItemAlert.textFields![0]
            // Test if text field is empty, and valid String
            if !(textField.text?.isEmpty)!, let newItemName = textField.text {
                // Add a new item using textfield.text as name
                self.list.itemsInList.append(newItemName)
                // Reload tableview data
                self.tableView.reloadData()
            }
        }))
        // Add cancel button
        addNewItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show alrt
        self.present(addNewItemAlert, animated: true, completion: nil)
    }

}

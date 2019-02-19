//
//  ListsTableViewController.swift
//  NunezJonathan_CE07
//
//  Created by Jonathan Nunez on 12/5/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    
    // MARK: Preparations
    // Empty GroceryList array
    var lists = [GroceryList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call method to populate default lists
        initializeDefaultGroceryLists()
        // Edit turns on "Select Mode"
        tableView.allowsMultipleSelectionDuringEditing = true
        // Register custom header xib
        tableView.register(UINib.init(nibName: "LTVC_SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "reuseSectionHeader")
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows is equivalent to objects in lists array
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set cell in tableviewcontroller to the custom cell controller
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! LTVC_TableViewCell

        // Configure the cell...
        cell.listNameLabel.text = lists[indexPath.row].listName
        cell.numberOfItemsLabel.text = lists[indexPath.row].numberOfItemsInList.description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Set height of section header to 75
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the header view
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "reuseSectionHeader") as? LTVC_SectionHeaderViewController
        // Config header view
        header?.sectionHeaderLabel.text = "Grocery Lists"
        header?.numberOf_Label.text = "Number of Lists:"
        header?.numberOfListsLabel.text = lists.count.description
        // Return view
        return header
    }
    
    // MARK: Table Editing Actions
    
    // Commit the edit if one is made
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the edit style is delete, then delete the row
        if editingStyle == .delete {
            // Build alert to confirm list deletion
            let deleteSingleList = UIAlertController(title: "Delete List", message: "Are you sure you want to delete the list?", preferredStyle: .alert)
            // Add delete button
            deleteSingleList.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
                // Update the data (delete the list) first
                // MUST delete the object first before deleting the row
                self.lists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                // Update the section header view
                let header = self.tableView.headerView(forSection: 0) as? LTVC_SectionHeaderViewController
                header?.numberOfListsLabel.text = self.lists.count.description
            }))
            // Add cancel button
            deleteSingleList.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // Show alert
            self.present(deleteSingleList, animated: true, completion: nil)
        }
            // Cover insertion
        else if editingStyle == .insert {
            
        }
    }
    
    // Fire when multi select row is chosen
    // Catches WillSelectRowAt callback
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.isEditing == true {
            print("Selecting Row: " + indexPath.row.description)
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.isEditing == true {
            print("Unselecting Row: " + indexPath.row.description)
        }
        return indexPath
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        // Enter edit mode, and exit edit mode
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing == true {
            // If edit mode is enabled, set leftBarButton to .trash, and call trash all selected method
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ListsTableViewController.trashAllSelected))
            // IF edit mode is enabled, set rightBarButton to .cancel, and call own method
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ListsTableViewController.editTapped(_:)))
        }
        else {
            // If edit mode is disabled then there will be no leftBarButton
            navigationItem.leftBarButtonItem = nil
            // If edit mode is disabled then reset rightBarButton to .edit
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ListsTableViewController.editTapped(_:)))
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        // Create a new list
    }
    
    // Loop through and delete all the comics and cells that have been selected in edit mode
    @objc func trashAllSelected() {
        // Build alert to confirm deletion of selected lists
        let deleteListsAlert = UIAlertController(title: "Delete Lists", message: "Are you sure you want to delete the list(s)?", preferredStyle: .alert)
        // Add delete button
        deleteListsAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
            // Get index of all selected rows
            if var selectedIPs = self.tableView.indexPathsForSelectedRows {
                // Sort in largest to smallest index, so we can remove items from back to front
                selectedIPs.sort { (a, b) -> Bool in
                    a.row > b.row
                }
                for indexPath in selectedIPs {
                    // Update the data (delete list) first
                    self.lists.remove(at: indexPath.row)
                }
                
                // Delete all the rows at once
                self.tableView.deleteRows(at: selectedIPs, with: .left)
                // Update custom section header
                let header = self.tableView.headerView(forSection: 0) as? LTVC_SectionHeaderViewController
                header?.numberOfListsLabel.text = self.lists.count.description
            }
        }))
        // Add cancel button
        deleteListsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show alert
        self.present(deleteListsAlert, animated: true, completion: nil)
    }
    
    @IBAction func addNewList(_ sender: UIButton) {
        // Test if custom section header was the initiator
        if (tableView.headerView(forSection: 0) as? LTVC_SectionHeaderViewController) != nil {
            // Call add new list alert
            addNewListAlert()
        }
    }
    
    func addNewListAlert() {
        // Build alert to create new list
        let addNewListAlert = UIAlertController(title: "Create New List", message: "Please enter the name of the list", preferredStyle: .alert)
        // Add a text field for user input
        addNewListAlert.addTextField { (textField) in
            // Set text field placeholder
            textField.placeholder = "Enter list name"
        }
        // Add a create button
        addNewListAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (alert) in
            // Get the text field from the alert itself
            let textField = addNewListAlert.textFields![0]
            // Test if textfield is empty, and if the text is valid String
            if !(textField.text?.isEmpty)!, let newListName = textField.text {
                // Build a new list using the textfield.text as the name
                self.lists.append(GroceryList(listName: newListName, itemsInList: []))
                // Reload table data
                self.tableView.reloadData()
            }
        }))
        // Add cancel button
        addNewListAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show alert
        self.present(addNewListAlert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == false {
            // Only allow cell selection to segue if the tableviewcontroller is not in editing mode
            self.performSegue(withIdentifier: "toITVC", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // When this view is shown again, update the custom section header data
        // And reload the tableview
        let header = self.tableView.headerView(forSection: 0) as? LTVC_SectionHeaderViewController
        header?.numberOfListsLabel.text = self.lists.count.description
        tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the index of the selected row
            if let indexPath = tableView.indexPathForSelectedRow {
                // Optional bind the grocerylist object
                let groceryListToSend = lists[indexPath.row]
                
                // test segue destination
                if let destination = segue.destination as? ItemsTableViewController {
                    // Set destination grocery list object to the optional binded grocery list object
                    destination.list = groceryListToSend
                }
            }
    }
}

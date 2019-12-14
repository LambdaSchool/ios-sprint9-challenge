//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Bobby Keffury on 12/13/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var entryController = EntryController()
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let entry = entryController.entries[indexPath.row]
        
        // Need to set these to the title and timestamp respectively.
        cell.textLabel?.text = entry
        cell.detailTextLabel?.text = entry
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addEntryAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: UIAlertController.Style.alert)
        
        addEntryAlert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }

        addEntryAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action: UIAlertAction!) in
            guard let text = addEntryAlert.textFields![0].text,
            let calories = Int(text) else { return }
            
            self.entryController.createEntry(with: calories)
            addEntryAlert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))

        addEntryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            addEntryAlert.dismiss(animated: true, completion: nil)
        }))

        present(addEntryAlert, animated: true, completion: nil)
    }
    
}

//
//  UsersTableViewController.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class UsersTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var entryController: EntryController?
    var userController = UserController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for entries frc: \(error)")
        }
        
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        let user = fetchedResultsController.object(at: indexPath)
        if let name = user.name {
            cell.textLabel?.text = name
        }
        if let entryCount = user.entries?.count {
            cell.detailTextLabel?.text = "Entries: \(entryCount)"
        }

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = fetchedResultsController.object(at: indexPath)
        selectUser(user)
    }
    
    // MARK: Private
    
    func selectUser(_ user: User) {
        NotificationCenter.default.post(name: .setUser, object: self, userInfo: ["user": user])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func compareAllUsers(_ sender: UIButton) {
        NotificationCenter.default.post(name: .showAllUsers, object: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add User", message: "Enter a name", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let name = alertController.textFields?[0].text else { return }
            
            let user = self.userController.create(user: name, context: CoreDataStack.shared.mainContext)
            
            self.selectUser(user)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
            textField.returnKeyType = .done
            textField.textContentType = .name
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .words
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: Fetched Results Controller Delegate

extension UsersTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("Unknown FRC change type")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}

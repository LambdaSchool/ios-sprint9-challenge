//
//  CaloriesViewController.swift
//  Calorie Tracker
//
//  Created by Isaac Lyons on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CaloriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet private weak var chart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    // MARK: Properties
    
    let entryController = EntryController()
    var user: User? {
        didSet {
            fetchedResultsController = newFRC()
            refreshViews()
            tableView.reloadData()
        }
    }
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry>? = newFRC()
    lazy var usersFRC: NSFetchedResultsController<User> = {
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
            fatalError("Error performing fetch for users frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        refreshViews()
        
        if user == nil {
            addButton.isEnabled = false
            performSegue(withIdentifier: "modalShowUsersList", sender: self)
        }
    }
    
    // MARK: Private
    
    private func newFRC(allUsers: Bool = false) -> NSFetchedResultsController<Entry>? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "user.name", ascending: true),
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        if let user = user {
            fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        } else if !allUsers {
            return nil
        }
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "user.name",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for entries frc: \(error)")
        }
        
        return frc
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: .dataUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUser(notification:)), name: .setUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(compareAllUsers), name: .showAllUsers, object: nil)
    }
    
    @objc private func refreshViews() {
        guard let frc = fetchedResultsController else { return }
        
        if user != nil {
            if let dataPoints = frc.fetchedObjects?.compactMap({ Double($0.calories) }) {
                let series = ChartSeries(dataPoints)
                chart.removeAllSeries()
                chart.add(series)
            }
        } else {
            if let users = usersFRC.fetchedObjects {
                var dataPoints: [User: [Double]] = [:]
                
                for user in users {
                    if let userEntries = frc.fetchedObjects?.filter({ $0.user == user }) {
                        let userDataPoints = userEntries.compactMap({ Double($0.calories) })
                        dataPoints[user] = userDataPoints
                    }
                }
                
                chart.removeAllSeries()
                for dataPointSet in dataPoints {
                    let series = ChartSeries(dataPointSet.value)
                    chart.add(series)
                }
            }
        }
    }
    
    @objc private func setUser(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let user: User = userInfo["user"] as? User else { return }
        
        self.user = user
        addButton.isEnabled = true
    }
    
    @objc private func compareAllUsers() {
        user = nil
        fetchedResultsController = newFRC(allUsers: true)
        refreshViews()
        tableView.reloadData()
        addButton.isEnabled = false
    }
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sectionIndexTitles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        if let entry = fetchedResultsController?.object(at: indexPath) {
            if user != nil {
                cell.textLabel?.text = "Calories: \(entry.calories)"
            } else {
                if let userName = entry.user?.name {
                    cell.textLabel?.text = "\(userName): \(entry.calories)"
                }
            }

            if let date = entry.date {
                cell.detailTextLabel?.text = dateFormatter.string(from: date)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let entry = fetchedResultsController?.object(at: indexPath) {
                entryController.delete(entry: entry, context: CoreDataStack.shared.mainContext)
                NotificationCenter.default.post(name: .dataUpdated, object: self)
            }
        }
    }
    
    // MARK: Actions

    @IBAction func addEntry(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let caloriesString = alertController.textFields?[0].text,
                let calories = Int16(caloriesString),
                let user = self.user else { return }
            
            self.entryController.create(entryWithCalories: calories, user: user, context: CoreDataStack.shared.mainContext)
            
            NotificationCenter.default.post(name: .dataUpdated, object: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Calories"
            textField.returnKeyType = .done
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Fetched Results Controller Delegate

extension CaloriesViewController: NSFetchedResultsControllerDelegate {
    
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

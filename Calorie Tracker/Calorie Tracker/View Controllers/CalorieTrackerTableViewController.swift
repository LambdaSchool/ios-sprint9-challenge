//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by patelpra on 6/13/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart



class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetechRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetechRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true), NSSortDescriptor(key: "created", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetechRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        return frc
        
    }()
    
    let calorieController = CalorieController()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorie = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calorie.calories ?? "0")"
        
        cell.detailTextLabel?.text = calorie.date

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                let calorie = self.fetchedResultsController.object(at: indexPath)
                self.calorieController.deleteCalorie(withCalorie: calorie)
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
}

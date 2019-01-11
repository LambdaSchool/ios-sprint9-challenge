//
//  CalorieIntakeTableViewController.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import CoreData

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK:- View lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK:- Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)
        
        let intake = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = intake.name

        return cell
    }
    
    
    // MARK:- IBActions
    
    @IBAction func newCalorieIntakeAmount(_ sender: Any) {
        CalorieIntakePopover.shared.trigger()
    }
    
    
    // MARK:- Types & properties
    
    let calorieIntakeController = CalorieIntakeController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        
        return frc
    }()

}

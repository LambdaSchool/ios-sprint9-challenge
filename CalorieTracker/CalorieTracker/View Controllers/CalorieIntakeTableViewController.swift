//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Joshua Rutkowski on 5/3/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

struct PropertyKeys {
    static let cell = "CalorieIntakeCell"
    static let date = "date"
    static let calorieIntakeAdded = "calorieIntakeAdded"
}

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var chart: Chart!
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PropertyKeys.date, ascending: true)]

        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: PropertyKeys.date, cacheName: nil)

        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }

        return frc
    }()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd yyyy 'at' h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    //MARK: - Private Functions
    
    private func add(calorieCount: String) {
        guard let calories = Int(calorieCount) else { return /* add alert? */}
        CalorieIntake(calorieCount: calories)
        save()
    }
    
    private func save() {
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            NotificationCenter.default.post(name: .calorieIntakeAdded, object: nil)
        } catch {
            print("Error saving to CoreDataStack: \(error)")
        }
    }
    
    // MARK: - IBActions
    

    @IBAction func addCalorieIntake(_ sender: Any) {
        let alert = UIAlertController(title: "Add calories?", message: "Type the number of calories you consumed today.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.add(calorieCount: alert.textFields?[0].text ?? "")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textfield in textfield.placeholder = "Calories" })

        self.present(alert, animated: true, completion: nil)
    }
    

}

// MARK: - Extensions


//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Andrew Liao on 9/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

private let moc = CoreDataStack.shared.mainContext

class CalorieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - Add Action
    
    @IBAction func addEntry(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories you ate today", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard let input = alert.textFields?[0].text,
            let calories = Int(input) else {return}
            self.entryController.create(withCalories: calories)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Calories"
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert,animated:true, completion:nil)

    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(entry.calories) calories"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        cell.detailTextLabel?.text = formatter.string(from: entry.date!)
        
        return cell
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var CalorieChart: Chart!
    private let entryController = EntryController()
    
    lazy var fetchedResultsController:NSFetchedResultsController<Entry> = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
}

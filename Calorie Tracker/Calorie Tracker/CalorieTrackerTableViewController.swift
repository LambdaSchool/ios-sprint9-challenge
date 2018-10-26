//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Moin Uddin on 10/26/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(frame: chartView.frame)
        // Create a new series specifying x and y values
        var count = 0
        var data:[(x: Double, y: Double)] = []
        for calorie in fetchedResultsController.fetchedObjects! {
            data.append((x: Double(count), y: Double(calorie.amount)))
            count += 1
        }
        let series = ChartSeries(data: data)
        chart.add(series)
        chartView.addSubview(chart)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntry", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories:  \(calorie.amount)"
        cell.detailTextLabel?.text = calorie.formattedDate

        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }


    @IBAction func addCalorieEntry(_ sender: Any) {
        let alert = UIAlertController(title: "Set Calories", message: nil, preferredStyle: .alert)
        var caloriesTextField: UITextField?
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
            caloriesTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in

        }
        alert.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            self.calorieEntryController.createCalorieEntry(amount: Int16((caloriesTextField?.text)!)!)
            self.tableView.reloadData()
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var chartView: UIView!
    
    let calorieEntryController = CalorieEntryController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        
        let moc = CoreDataStack.shared.mainContext
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
}

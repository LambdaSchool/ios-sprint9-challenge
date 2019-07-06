//
//  CalorieChartTableViewController.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChartTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
     //requires notification center to call a function to update the chart

    override func viewDidLoad() {
        super.viewDidLoad()

        // load the chart empty instance? or just let it run blank for now bc first time thru there will be no chart so prefer viewWillAppear
        let data = calorieEntryController.calories
        let series = ChartSeries(data)
        chart.add(series)

    }
    
    @IBAction func refreshTable(_ sender: Any) {
        self.refreshControl?.endRefreshing()
    }
    
    
    @IBAction func AddCalorieDatapoint(_ sender: Any) {
        
        // show alert controller
        // grab user-entered calorie data
        
        let alertController = UIAlertController(title: "What's In Your Trough?", message: "Enter the calories inhaled today!", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: calorieTextField)
        
        let enterAction = UIAlertAction(title: "ENTER", style: .default, handler: self.enterHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(enterAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    
    }
    
    func calorieTextField(textField: UITextField!) {
        calorieTextField = textField
        calorieTextField?.placeholder = "Calories [no decimals]"
    }
    
    func enterHandler(alert: UIAlertAction!) {
        
        // Make sure User entered safe Integer data
        guard let calorie = Double(calorieTextField!.text!) else {return}
        
        // create an array with the new calorieEntry (tested SAT the alertcontroller gets good data)
        calorieEntryController.addUserEnteredData(calorie: calorie)

        // display in TableView (from calorie entries array)
        tableView.reloadData()
        
        let data = calorieEntryController.calories
        let series = ChartSeries(data)
        chart.add(series)
        
        // concurrency: due to size of project, not necessarily needed, but if any task is cpu intense it would be pulling the calorie entries data from Core Data to display on the chart
        
    }
    
    //MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return calorieEntryController.calories.count
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)
        
        let calorieEntry = fetchedResultsController.object(at: indexPath)
        let calorieCell = calorieEntry.calorie
        let timestampCell = calorieEntry.timestamp

        // Configuration: Calories on left; timestamp on right
        //let calorieCell = calorieEntryController.calories[indexPath.row]
        cell.textLabel?.text = "Calories: \(String(describing: calorieCell))"
        
        
        // will need to access calorieEntry.timestamp
        cell.detailTextLabel?.text = stringFromDate(date: timestampCell!)

        return cell
    }
    
    //MARK: Properties
    
    
    private func stringFromDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
        return dateFormatter.string(from: date)
    }
    
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
        
    }()
    
    
    @IBOutlet weak var chart: Chart!
    
    //let series = ChartSeries(data: data)  this is an example of what ChartSeries wants, but it will assign the index of an array to the x-value automatically, so it's not required to create a tuple
    
    var calorieEntry = CalorieEntry()
    
    var calorieTextField: UITextField?
    
    var calorieEntryController = CalorieEntryController()

}

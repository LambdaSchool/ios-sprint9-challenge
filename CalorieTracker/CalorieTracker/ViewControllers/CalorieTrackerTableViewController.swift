//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Sameera Roussi on 6/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var chart = Chart()
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartFrame = CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height)
        chart = Chart(frame: chartFrame)
        chartView.addSubview(chart)
        
        // Create notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalorieChart), name: .updateCalorieChart, object: nil)
        
        updateCalorieChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // Add Calorie data action
    @IBAction func addCalorieDataTapped(_ sender: Any) {
        let inputDialog = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        // Placeholder text
        inputDialog.addTextField { (caloriesInput) in caloriesInput.placeholder = "Calories"}
        
        // Dialog submit action
        let submitAction = UIAlertAction(title: "Submit", style: .default) { ( _ ) in
            // Make sure there is a text field
            guard let caloriesInputField = inputDialog.textFields?[0],
                let fieldText = caloriesInputField.text else { return }
                let caloriePoint = Int16(fieldText) ?? 0
            self.calorieDataController.addCalorieDataPoint(newCalories: caloriePoint)
            
            NotificationCenter.default.post(name: .updateCalorieChart, object: nil)
            }

        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        inputDialog.addAction(submitAction)
        inputDialog.addAction(cancelAction)
        
         self.present(inputDialog, animated: true, completion: nil)
    }
    
    
    // MARK: - Update Calorie Chart
    @objc func updateCalorieChart() {
        
        guard let allCaloriePoints = fetchedResultsController.fetchedObjects?.compactMap({ Double($0.caloriesRecorded) }) else { return }
        let series = ChartSeries(allCaloriePoints)
        chart.add(series)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
         return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)
        
        let calorieData = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Calories: \(calorieData.caloriesRecorded)"
        cell.detailTextLabel?.text = formattedDate.string(from: calorieData.dateRecorded ?? Date())

        return cell
    }
    

    // MARK: -  Fetched Results Controller delegate functions
    // Will Change Content
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Change update delegate functions
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("This functionality has not been implemented yet.")
        }
    }
    
    // Delete changes
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                      for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    // Did Change End
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Fetched Results Controller implementation
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateRecorded", ascending : true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try!frc.performFetch()
        return frc
    }()
    
     // MARK: SwiftChart View Configuration
    // UIView outlet for SwiftChart Chart
    @IBOutlet weak var chartView: UIView!

    // MARK: - Properties
    // Date formatter
    var formattedDate: DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
        return dateformatter
    }
    
    let calorieDataController = CalorieDataController()
    
}
  
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    



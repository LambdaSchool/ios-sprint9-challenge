//
//  CalorieIntakeTableViewController.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

extension NSNotification.Name {
    static let updateChart = NSNotification.Name("updateChart")
}

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
    let calorieIntakeController = CalorieIntakeController()
    
    lazy var frc: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "person", ascending: true), NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "person",
                                             cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

    var caloriesByPerson: [String : [CalorieIntake]]!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a dictionary that is grouped by person, e.g. ["Stefano" : [CalorieIntake],  "Billy" : [CalorieIntake]]
        guard let calories = frc.fetchedObjects else { return }
        caloriesByPerson = Dictionary(grouping: calories, by: { $0.person ?? "" })
        
        // Send notification to ChartView with calorie series stored in local persistence
        let nc = NotificationCenter.default
        nc.post(name: .updateChart, object: caloriesByPerson)
        
    }
    
    // MARK: - Actions
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below", preferredStyle: UIAlertController.Style.alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (alertAction) in
            let calorieTextField = alert.textFields![0] as UITextField
            let nameTextField = alert.textFields![1] as UITextField
            if let calorieInput = Int16(calorieTextField.text ?? ""), let personName = nameTextField.text {
                // Create new calorie intake instance
                self.calorieIntakeController.create(with: calorieInput, for: personName)
                
                guard let calories = self.frc.fetchedObjects else { return }
                self.caloriesByPerson = Dictionary(grouping: calories, by: { $0.person ?? "" })
                
                // Setup notification center and set calorieSeries -> [Double]
                let nc = NotificationCenter.default
                nc.post(name: .updateChart, object: self.caloriesByPerson)
                
                // Update table view with new calorie intake
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            // Dismiss if pressed on cancel
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories..."
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your name..."
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func getCalorieSeries() -> [Double] {
        return self.frc.fetchedObjects?.map { Double($0.calorie) } ?? []
    }
    
    private func formatDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
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
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            //tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
            // could also do:
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return frc.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)

        let calorieIntake = frc.fetchedObjects?[indexPath.row]
        
        if let calorieIntake = calorieIntake, let timestamp = calorieIntake.timestamp {
            cell.textLabel?.text = "Calorie: \(calorieIntake.calorie)"
            cell.detailTextLabel?.text = formatDate(for: timestamp)
        }
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}

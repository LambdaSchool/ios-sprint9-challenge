//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {

    let calorieIntakeController = CalorieIntakeController()
    
    
    
//    let chart: Chart = {
//        let c = Chart()
//
//
//
//        let data = [(x: 0, y: 0),
//                    (x: 2, y: 250),
//                    (x: 3, y: 500),
//                    (x: 4, y: 750),
//                    (x: 5, y: 1000)
//        ]
//        let series = ChartSeries(data: [(x: 0, y: 0),
//                                        (x: 2, y: 250),
//                                        (x: 3, y: 500),
//                                        (x: 4, y: 750),
//                                        (x: 5, y: 1000)])
//
//
//        c.xLabels = xLabelArray
//        c.add(series)
//        return c
//    }()
    
    
    
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "date", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        chartView = chart
//        calorieTrackerTableViewController.d
//        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//        let data: [(Double, Double)] = [(x: 0, y: 0),
//                    (x: 2, y: 250),
//                    (x: 3, y: 500),
//                    (x: 4, y: 750),
//                    (x: 5, y: 1000)
//        ]
//        let series = ChartSeries(data: data)
//        chart.add(series)
//        var xLabelArray: [Double] = []
//        for number in 0...30 {
//            xLabelArray.append(Double(number))
//        }
    }
    @IBAction func addCalorieIntakeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "Enter Calorie Amount:"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text {
                _ = CalorieIntake(calories: Int(calories) ?? 0, date: Date(), context: CoreDataStack.shared.mainContext)
                self.calorieIntakeController.saveToPersistentStore()
            }
        }))
        self.present(alert, animated: true)
    }
            
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath) 

        let calorieIntake = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Calories: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorieIntake.date ?? Date())

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieIntake = fetchedResultsController.object(at: indexPath)
            calorieIntakeController.delete(for: calorieIntake)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
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
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension CalorieTrackerTableViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    
}

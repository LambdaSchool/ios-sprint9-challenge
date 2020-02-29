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
    
    var count: Int = 0
    
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
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @IBOutlet weak var chartView: Chart!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .refreshViews, object: nil)
        updateViews()
    }
    
    @IBAction func addCalorieIntakeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "Enter Calorie Amount:"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text, !calories.isEmpty {
                _ = CalorieIntake(calories: Int(calories) ?? 0, date: Date(), context: CoreDataStack.shared.mainContext)
                self.calorieIntakeController.saveToPersistentStore()
                NotificationCenter.default.post(name: .refreshViews, object: self)
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

    func updateViews() {
        guard let calories = fetchedResultsController.fetchedObjects else { return }
        calorieIntakeController.calorieIntakes = []
        for object in calories {
            self.calorieIntakeController.calorieIntakes.append(Double(object.calories))
        }
        let series = ChartSeries(calorieIntakeController.calorieIntakes)
        series.color = ChartColors.blueColor()
        series.area = true
        chartView.add(series)
    }
    
    @objc func refreshViews(_ notification: Notification) {
        guard let calories = fetchedResultsController.fetchedObjects else { return }
        calorieIntakeController.calorieIntakes = []
        for object in calories {
            self.calorieIntakeController.calorieIntakes.append(Double(object.calories))
        }
        let series = ChartSeries(calorieIntakeController.calorieIntakes)
        series.color = ChartColors.blueColor()
        series.area = true
        chartView.add(series)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieIntake = fetchedResultsController.object(at: indexPath)
            calorieIntakeController.delete(for: calorieIntake)
            NotificationCenter.default.post(name: .refreshViews, object: self)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

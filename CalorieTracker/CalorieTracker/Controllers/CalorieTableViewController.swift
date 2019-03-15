//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_34 on 3/15/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(refreshViews(_:)), name: .calorieIntakeChange, object: nil)
    }
    
    //MARK: - Properties
    var calorieController = CalorieController()
    var series: ChartSeries!
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    //MARK: - Outlets
    @IBOutlet weak var calorieChart: Chart!
    @IBAction func addCalories(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the text field below:", preferredStyle: .alert)
        
        var caloriesTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
            caloriesTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            guard let caloriesString = caloriesTextField?.text, !caloriesString.isEmpty,
                let calories = Double(caloriesString) else { return }
            
            self.calorieController.create(calories: calories)
            NotificationCenter.default.post(name: .calorieIntakeChange, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Notification
    @objc func refreshViews(_ notification: Notification) {
        tableView.reloadData()
    }
    
    private func updateChart() {
        guard var allcalories = fetchedResultsController.fetchedObjects?.compactMap({$0.calories}) else { return }
        allcalories.insert(0.0, at: 0)
        
        self.series = ChartSeries(allcalories)
        self.series.color = ChartColors.pinkColor()
        self.series.area = true
        calorieChart.add(self.series)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)

        let calorieIntake = fetchedResultsController.object(at: indexPath)
        let date = String(from: calorieIntake.timestamp!)

        cell.textLabel?.text = "Calories: \(Int(calorieIntake.calories))"
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let calorieIntake = fetchedResultsController.object(at: indexPath)
            calorieController.delete(calorieIntake: calorieIntake)
        }
        NotificationCenter.default.post(name: .calorieIntakeChange, object: nil)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
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
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
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

}

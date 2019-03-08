//
//  CalorieChartTableViewController.swift
//  Calorie Tracker
//
//  Created by Moses Robinson on 3/8/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChartTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()
        observeCalorieIntakeChanged()
    }
    
    @IBAction func addCalorieIntakeButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below:", preferredStyle: .alert)
        
        var caloriesTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Amount:"
            caloriesTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            guard let caloriesString = caloriesTextField?.text, !caloriesString.isEmpty,
                let calories = Double(caloriesString) else { return }
            
            self.calorieIntakeController.create(calories: calories)
            NotificationCenter.default.post(name: .calorieIntakeChanged, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateChart() {
        calorieChart.series.removeAll()
        
        guard var allcalories = fetchedResultsController.fetchedObjects?.compactMap({$0.calories}) else { return }
        allcalories.insert(0.0, at: 0)

        self.series = ChartSeries(allcalories)
        self.series.color = ChartColors.orangeColor()
        self.series.area = true
        calorieChart.add(self.series)
    }
    
    func observeCalorieIntakeChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: .calorieIntakeChanged, object: nil)
    }
    
    @objc func refreshViews() {
        updateChart()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    let reuseIdentifier = "CalorieIntakeCell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let calorieIntake = fetchedResultsController.object(at: indexPath)
        let date = formatter.string(from: calorieIntake.timestamp!)
        
        cell.textLabel?.text = "Calories: \(Int(calorieIntake.calories))"
        cell.detailTextLabel?.text = date
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let calorieIntake = fetchedResultsController.object(at: indexPath)
            
            calorieIntakeController.delete(calorieIntake: calorieIntake)
        }
        NotificationCenter.default.post(name: .calorieIntakeChanged, object: nil)
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
    
    // MARK: - Properties
    
    var calorieIntakeController = CalorieIntakeController()
    
    var series: ChartSeries!
    
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        return result
    }()
    
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
    
    @IBOutlet var calorieChart: Chart!
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Hunter Oppel on 5/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
        
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var calorieChartSeries = ChartSeries([])
    
    let calorieController = CalorieController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        calorieChart.minY = 100
        
        calorieChartSeries.area = true
        calorieChartSeries.colors.below = .blue
        
        calorieChart.add(calorieChartSeries)
        updateChart()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .didCreateNewCalorie, object: nil)
    }
    
    @objc private func refreshView() {
        updateChart()
        tableView.reloadData()
    }
    
    // MARK: - Add Calories to Table View
    
    @IBAction func addCalorie(_ sender: Any) {
        presentAlert()
    }
        
    private func presentAlert() {
        let title = "Add Calorie Intake"
        let message = "Enter the amount of calories in the field"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let textField = alert.textFields![0]
            guard let amount = textField.text else { return }
            self.calorieController.createCalorie(amount: amount)
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Add Calories to Chart
    
    private func updateChart() {
        calorieChart.removeAllSeries()
        
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        do {
            var calorieAmounts = [(x: Double, y: Double)]()
            let calories = try context.fetch(fetchRequest)
            
            for (index, calorie) in calories.enumerated() {
                guard let amountString = calorie.amount,
                    let amount = Double(amountString) else { return }
                calorieAmounts.append((x: Double(index), y: amount))
            }
            
            calorieChartSeries.data = calorieAmounts
            
            calorieChart.series.append(calorieChartSeries)
        } catch {
            NSLog("Failed to fetch calories.")
            return
        }
    }
}

// MARK: - Table View Extension

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        
        guard let amount = calorie.amount,
            let date = calorie.date else {
                NSLog("No amount or date in calorie, returning empty cell.")
                return UITableViewCell()
        }
        
        cell.textLabel?.text = "Calories: \(amount)"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: date))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorie = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(calorie)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
            
            updateChart()
        }
    }
}

// MARK: - Fetched Results Extension

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
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
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
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

//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Julian A. Fordyce on 3/15/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import SwiftChart
import CoreData


class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateChartViews()
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
    }
    
    @objc func shouldShowChartDataChanged(_ notification: Notification) {
        clearChart()
        chartView.removeAllSeries()
        updateChartViews()
        tableView.reloadData()
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calories = alertController.textFields?[0].text
            let caloriesDouble = Double(calories ?? "0")
            self.calorieIntakeController.createIntake(calories: caloriesDouble!, timestamp: Date())
            NotificationCenter.default.post(name: .shouldShowChartDataChanged, object: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieIntakeController.caloriesIntake.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let calorieIntake = calorieIntakeController.caloriesIntake[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorieIntake.calories)"
        if calorieIntake.formattedTimeStamp != nil {
            cell.detailTextLabel?.text = "\(calorieIntake.formattedTimeStamp!)"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieIntake = calorieIntakeController.caloriesIntake[indexPath.row]
            calorieIntakeController.deleteIntake(calorieIntake: calorieIntake)
            tableView.deleteRows(at: [indexPath], with: .fade)
            clearChart()
            chartView.removeAllSeries()
            updateChartViews()
            NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
        }
    }

    func clearChart() {
        data = [(0, 0.0)]
    }
    
    func updateChartViews() {
        for intake in calorieIntakeController.caloriesIntake {
            let intake = intake as? CalorieIntake
            data.append((data.count, Double(intake!.calories)))
        }
        let series = ChartSeries(data: data)
        series.area = true
        series.color = ChartColors.goldColor()
        chartView.add(series)
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
        
    }()
    

    @IBAction func add(_ sender: Any) {
        showAlertController()
    }
    
    // MARK: - Properties
    @IBOutlet weak var chartView: Chart!
    private var data: [(Int, Double)] = [(0, 0.0)]
    let calorieIntakeController = CalorieIntakeController()
    var calorieIntake: CalorieIntake!
}

extension NSNotification.Name {
    static let shouldShowChartDataChanged = NSNotification.Name("ShouldShowChartDataChanged")
}

//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Joshua Rutkowski on 5/3/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

struct PropertyKeys {
    static let cell = "CalorieCell"
    static let date = "date"
    static let calorieIntakeAdded = "calorieIntakeAdded"
}

class CalorieIntakeTableViewController: UITableViewController {
    
    let calorieController = CalorieController()
    
    @IBOutlet private var chart: Chart!
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PropertyKeys.date, ascending: true)]

        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: PropertyKeys.date, cacheName: nil)

        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }

        return frc
    }()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL dd yyyy 'at' h:mm:ss a"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChart),
                                               name: .calorieIntakeAdded,
                                               object: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            calorieController.deleteCalorie(fetchedResultsController.object(at: indexPath))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cell, for: indexPath)

        let calorieIntake = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "Calories: \(calorieIntake.calorieCount)"

        if let date = calorieIntake.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = "No date available"
        }

        return cell
    }


    // MARK: - Private Functions
    
    @objc private func updateChart() {
        var caloriesArray: [Double] = []
        let calorieIntakes = fetchedResultsController.fetchedObjects

        calorieIntakes?.forEach { caloriesArray.append(Double($0.calorieCount)) }

        let series = ChartSeries(caloriesArray)
        series.color = ChartColors.cyanColor()
        series.area = true
        chart.add(series)
    }
    
    private func add(calorieCount: String) {
        guard let calories = Int(calorieCount) else { return }
        CalorieIntake(calorieCount: calories)
        save()
    }
    
    private func save() {
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
            NotificationCenter.default.post(name: .calorieIntakeAdded, object: nil)
        } catch {
            print("Error saving to CoreDataStack: \(error)")
        }
    }
    
    // MARK: - IBActions
    

    @IBAction func addCalorieIntake(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.add(calorieCount: alert.textFields?[0].text ?? "")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textfield in textfield.placeholder = "Calories" })

        self.present(alert, animated: true, completion: nil)
    }
    

}

// MARK: - Extensions

extension CalorieIntakeTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}

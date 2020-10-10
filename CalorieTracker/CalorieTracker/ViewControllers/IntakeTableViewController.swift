//
//  IntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Cora Jacobson on 10/10/20.
//

import UIKit
import CoreData
import SwiftChart

class IntakeTableViewController: UITableViewController {
    
    @IBOutlet private weak var chartView: Chart!
    
    let formatter = DateFormatter()
    let chart = Chart(frame: .zero)
    var calorieSeries = [Double]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Intake> = {
        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Unable to fetch intakes from main context: \(error)")
        }
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        updateChart()
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .shouldUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "intakeCell", for: indexPath)
        let date = formatter.string(from: fetchedResultsController.object(at: indexPath).timestamp ?? Date())
        cell.textLabel?.text = "Calories: \(fetchedResultsController.object(at: indexPath).calories)"
        cell.detailTextLabel?.text = date
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let intake = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(intake)
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addIntake(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        var caloriesTextField: UITextField!
        alert.addTextField { textField in
            textField.placeholder = "calories"
            caloriesTextField = textField
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            let calories = Int(caloriesTextField.text ?? "0") ?? 0
            self.saveIntake(calories)
        })
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveIntake(_ calories: Int) {
        Intake(calories: calories)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        NotificationCenter.default.post(name: .shouldUpdate, object: nil)
    }
    
    @objc func updateChart() {
        calorieSeries = []
        if let objects = fetchedResultsController.fetchedObjects {
            for object in objects {
                calorieSeries.append(Double(object.calories))
            }
        }
        let series = ChartSeries(calorieSeries)
        series.color = ChartColors.purpleColor()
        series.area = true
        chartView.add(series)
    }
    
}

extension IntakeTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
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
        default:
            break
        }
    }
    
}

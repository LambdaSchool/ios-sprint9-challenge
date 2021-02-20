//
//  ViewController.swift
//  CalorieTracker
//
//  Created by John McCants on 10/9/20.
//  Copyright © 2020 John McCants. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: UIView!
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 318))
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
        
        return dateFormatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
            
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
            return frc
        } catch {
            fatalError("Error Fetching: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
    }
    
    func updateViews() {
        tableView.reloadData()
        guard let sections = fetchedResultsController.sections else {return}
        chart.removeAllSeries()
        
        
        var doubleData: [Double] = []
        var countArray: [Double] = [0]
        var index: Double = 0
        
        
        for section in sections {
            if let objects = section.objects as? [Calories] {
                for object in objects {
                    doubleData.append(Double(object.calories))
                    index += 1
                    countArray.append(index)
                    print(index)
                }
            }
        }
        let series = ChartSeries(doubleData)
        chart.add(series)
        chart.xLabels = countArray
        series.color = ChartColors.greenColor()
        series.area = true
        chartView.addSubview(chart)
    }
    
    func saveCalories(calories: Int) {
        _ = Calories(calories: calories)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            print("Error saving object: \(error)")
        }
    }
    
    func alertPresent() {
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let caloriesText = alert.textFields?.first?.text else { return }
            
            
            guard let caloriesNumber = Int(caloriesText) else { print("Must enter a number")
                return}
            
    
            self.saveCalories(calories: caloriesNumber)
            self.updateViews()
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        alert.addTextField { (_) in
            print("Textfield added")
        }
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        alertPresent()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CalorieTableViewCell else { return UITableViewCell() }
        
        let calories = fetchedResultsController.object(at: indexPath)
        let timestamp = calories.timestamp
        cell.caloriesLabel.text = "Calories: \(calories.calories)"
        
        cell.dateLabel.text = dateFormatter.string(from: timestamp ?? Date())
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let calories = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(calories)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                NSLog("Error saving managed object: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateViews()
            }
        }
    }
    
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
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
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Thomas Dye on 6/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {

        @IBOutlet private weak var calorieChart: Chart!
        @IBOutlet private weak var caloriesTableView: UITableView!
        
        let calorieController = CalorieController()
    
        lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
            
            // Create fetch request, NSSortDescriptor, Managed Object Context, and Fetched Results Controller
            let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: .timeStamp, ascending: true)]
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
        
        @objc func updateViews() {
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateViews),
                                                   name: .calorieLogChanged,
                                                   object: nil)
            caloriesTableView.reloadData()
            guard let sections = fetchedResultsController.sections else { return }
            calorieChart.removeAllSeries()
            
            var seriesOfDoubles: [Double] = []
            for section in sections {
                if let objects = section.objects as? [Calorie] {
                    for object in objects {
                        seriesOfDoubles.append(Double(object.amount))
                    }
                }
            }
            
            calorieChart.axesColor = .red
            calorieChart.gridColor = .red
            calorieChart.add(ChartSeries(seriesOfDoubles))
            
        }

        @IBAction func addButtonTapped(_ sender: Any) {
            
            // Create alert
            let alert = UIAlertController(title: "Add calorie intake",
                                          message: "Enter the amount of calories",
                                          preferredStyle: .alert)
            
            // Add text field
            alert.addTextField { textField in
                textField.placeholder = "Calories"
            }
            
            // Save button - if textField is NaN returns an error alert.
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
                
                if alert.textFields?.first?.text?.isNumeric == false {
                    self.failedToEnterCaloriesAlert()
                    print("it's empty")
                }
                guard let currentTextField = alert.textFields,
                    let caloriesString = currentTextField[0].text,
                    let calories = Int(caloriesString)
                else {
                    return
                }
                // Create calories from given integer.
                self.calorieController.create(amount: calories)
            }))
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .destructive,
                                          handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    // Function to display alert when entering NaN
    func failedToEnterCaloriesAlert() {
        let alert = UIAlertController(title: "Error Adding Calories",
                                      message: "You did not enter a number.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let calorie = fetchedResultsController.object(at: indexPath)
            calorieController.delete(calorie: calorie) { _ in
                DispatchQueue.main.async {
                    self.caloriesTableView.reloadData()
                }
            }
        }
    }
}

extension CalorieTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: .calorieCell, for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        guard let timestamp = calorie.timestamp else {
            return UITableViewCell()
        }
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
            cell.textLabel?.text = "\(calorie.amount) Cals"
            cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
            return cell
        }
    }

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        caloriesTableView.beginUpdates()
    }
        
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        caloriesTableView.endUpdates()
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
            
        switch type {
        case .insert:
            caloriesTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            caloriesTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            caloriesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            caloriesTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            caloriesTableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            caloriesTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension String {
    static var calorieCell = "CalorieCell"
    static var timeStamp = "timestamp"
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

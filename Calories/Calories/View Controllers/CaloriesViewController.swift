//
//  CaloriesViewController.swift
//  Calories
//
//  Created by Norlan Tibanear on 10/10/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesViewController: UIViewController {
    
    // Outlets

    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Properties
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
            
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
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
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        self.viewDidLoad()
    }
    
    @objc func updateViews() {
           NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .calorieChanged, object: nil)
        
           tableView.reloadData()
           guard let sections = fetchedResultsController.sections else { return }
           calorieChart.removeAllSeries()
               
           var seriesOfDoubles: [Double] = []
        
           for section in sections {
               if let objects = section.objects as? [Calorie] {
                   for object in objects {
                       seriesOfDoubles.append(Double(object.calories))
                   }
               }
           }
        
        let seriesType = ChartSeries(seriesOfDoubles)
        seriesType.color = ChartColors.pinkColor()
        seriesType.area = true

        calorieChart.add(seriesType)
        calorieChart.yLabels = [0, 250, 500, 750, 1000]
        calorieChart.labelColor = .systemTeal
        
//        calorieChart.tintColor = .systemPink
//        calorieChart.labelColor = .systemTeal
//           calorieChart.add(ChartSeries(seriesOfDoubles))
       }

    
    
    @IBAction func addCalorieButton(_ sender: Any) {
        
        // Create alert
            let alert = UIAlertController(title: "Add calories", message: "Enter calories amount", preferredStyle: .alert)
                
            // Add text field
            alert.addTextField { textField in
                textField.placeholder = "Calories"
            }
                
            // Save button 
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
                
                guard let currentTextField = alert.textFields,
                    let caloriesString = currentTextField[0].text,
                    let calories = Int(caloriesString)
                    else {
                        return
                }
                // Create calories from given value
                self.saveCalorie(calories)
                self.tableView.reloadData()
                self.updateViews()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        // Function to display alert
        func failedToEnterCaloriesAlert() {
            let alert = UIAlertController(title: "Error", message: "Please add the amount of calories.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        
    }// addCalorieButton
    
    
    private func saveCalorie(_ calories: Int) {
        let calorie = Calorie(calories: calories)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object: \(error)")
        }
    }
    
    

} // CaloriesViewController

extension CaloriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath)
        
        guard let timestamp = calorie.timestamp else {
            return UITableViewCell()
        }
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
            cell.textLabel?.text = "\(calorie.calories) Cals"
            cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let calorie = fetchedResultsController.object(at: indexPath)
            let moc = CoreDataStack.shared.mainContext
            moc.delete(calorie)
            
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
    
    
} //


extension CaloriesViewController: NSFetchedResultsControllerDelegate {
    
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
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}//



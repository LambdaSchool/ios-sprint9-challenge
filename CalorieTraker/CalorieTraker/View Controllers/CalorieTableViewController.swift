//
//  CalorieTableViewController.swift
//  CalorieTraker
//
//  Created by denis cedeno on 5/1/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart



class CalorieTableViewController: UITableViewController {

    @IBOutlet weak var chart: Chart!
     
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
          let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
          fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
          let moc = CoreDataStack.shared.mainContext
          let frc = NSFetchedResultsController(
                                              fetchRequest: fetchRequest,
                                              managedObjectContext: moc,
                                              sectionNameKeyPath: "date",
                                              cacheName: nil)
          frc.delegate = self
          try! frc.performFetch()
          return frc
      }()

    private let calorieController = CalorieController()
    
    
    @IBAction func addCalorie(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the amount of calories in the field",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Calories"
        }
        
        let submit = UIAlertAction(title: "Submit",
                                   style: .default) { _ in
            if let entry = alert.textFields?.first?.text,!entry.isEmpty {
                let calories = Int16(entry) ?? 0
                self.calorieController.appendCalories(calories: calories)
                self.updateChart()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel,
                                   handler: nil)
        
        alert.addAction(submit)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Calorie Tracker"
        updateChart()
    }
    
    func updateChart() {
        
        let caloriePoints = fetchedResultsController.fetchedObjects ?? []
        
               var chartPoints: [Double] = []
               
               for point in caloriePoints {
                   let points = Double(point.calories)
                   chartPoints.append(points)
               }
               
               chart.removeAllSeries()
               
               let series = ChartSeries(chartPoints)
               series.area = true
               chart.add(series)
               
               // Set minimum and maximum values for y-axis
               chart.minY = 0
               chart.maxY = 4000

               // Format y-axis, e.g. with units
               chart.yLabelsFormatter = { String(Int($1)) +  " Calories" }
               
               series.colors = (
                 above: ChartColors.redColor(),
                 below: ChartColors.blueColor(),
                 zeroLevel: 2000
               )

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieCell else { return UITableViewCell() }
        cell.delegate = self
        cell.calorie = fetchedResultsController.object(at: indexPath)
        return cell
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let calorie = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(calorie)
            do {
                try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
                
            } catch {
                CoreDataStack.shared.mainContext.reset()
                print("Error saving managed object context: \(error)")
            }
            
        }
    }
    
}

extension CalorieTableViewController: NSFetchedResultsControllerDelegate {
    
    // Four Methods:
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // when controller detects changes are going to happen
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // once we finished with all the changes this marks that we are done
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        // insert or delete entire sections from table view, we create a switch on NSFetchresultschangetype .insert or .delete
        switch type {
        case .insert:
            // indexSet wants an interger from section
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            // indexSet wants an interger from section
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
        // switching on type
        switch type {
        case .insert:
            // new task
            // unwrapp newIndexPath because its optional
            guard let newIndexPath = newIndexPath else { return }
            // insert a row into the screen instead of reloading entire table
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            // reload rows at index path instead of the entire table view
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            // move task from section its in to a new section and this involves two steps .deleteRows and .insertRows
            // unwrapp old and new indexpaths
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // handeling future unknown values with @unknown
        @unknown default:
            break
        }
    }
}

extension CalorieTableViewController: ChartsTableViewControllerDelegate {
    func chartDataChanged(newValueof: Calorie) {
        updateChart()
    }
}

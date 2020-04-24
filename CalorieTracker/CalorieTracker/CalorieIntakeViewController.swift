//
//  CalorieIntakeViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_268 on 4/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
     @IBOutlet weak var calorieChart: UIView!


    let calorieController = CaloriesController()


    // MARK: - IBActions
    @IBAction func addCaloriesButton(_ sender: UIBarButtonItem) {
           let alertController = UIAlertController(title: "Add Calorie Amount", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
           alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Calories:"
           }
           let submitAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { alert -> Void in
               let firstTextField = alertController.textFields![0] as UITextField
               guard let caloriesCount = firstTextField.text else { return }

             self.calorieController.createCalorie(withCalorieAmount: caloriesCount)
               NotificationCenter.default.post(name: .updateChart, object: self)
               self.tableView.reloadData()
           })
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
           alertController.addAction(cancelAction)
           alertController.addAction(submitAction)

           self.present(alertController, animated: true, completion: nil)
       }

    // MARK: - ObjC Update Chart
     @objc func updateChart(notification: Notification) {

         let cChart = Chart(frame: calorieChart.frame)

         var data: [Double] = []

         for calorie in fetchedResultsController.fetchedObjects! {
             print(calorie.amount)
            data.append(Double(calorie.amount!) as? Double ?? 0.0)
         }

         let series = ChartSeries(data)
         series.area = true
         cChart.add(series)

         self.calorieChart.subviews.forEach({ $0.removeFromSuperview() })
         self.calorieChart.addSubview(cChart)


     }



    // MARK: - View Did Load && View Did Appear
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .updateChart, object: self)
    }


    // MARK: - Fetched Results Controller
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeAdded",
                                                         ascending: true),
                                        NSSortDescriptor(key: "timeAdded",
                                                         ascending: true)]

        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        try! frc.performFetch()
        return frc
    }()

    // MARK: - Table view data source
       override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           self.fetchedResultsController.sections?.count ?? 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
       }


       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as UITableViewCell

           let calorie = self.fetchedResultsController.object(at: indexPath)
           cell.textLabel?.text = "Calories: \(calorie.amount ?? "0")"

        cell.detailTextLabel?.text = calorie.date
        return cell
       }



       // Override to support editing the table view.
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               let calorie = self.fetchedResultsController.object(at: indexPath)
               self.calorieController.deleteCalories(withCalorie: calorie)

               tableView.deleteRows(at: [indexPath], with: .fade)
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }


    // MARK: - Controller Methods
    
       func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           self.tableView.beginUpdates()
       }

       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           self.tableView.endUpdates()
       }

       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
           switch type {
           case .insert:
               self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
           case .delete:
               tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
           default:
               break
           }
       }

       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           switch type {
           case .insert:
               guard let newIndexPath = newIndexPath else { return }
               self.tableView.insertRows(at: [newIndexPath], with: .automatic)
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

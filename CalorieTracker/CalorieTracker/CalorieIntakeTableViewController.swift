//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Thomas Cacciatore on 7/5/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let data = [
            (x: 0, y: 0.0),
            (x: 1, y: 3.0),
            (x: 4, y: 5.0),
            (x: 5, y: 2.0)
        ]
        let series = ChartSeries(data: data)
        chart.add(series)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .intakeAdded, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let chart = Chart()
//        let series = ChartSeries(intakeController.calories)
//        series.area = true
//        series.color = ChartColors.blueColor()
//        chart.add(series)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .intakeAdded, object: nil)
    }
    

    //Chart stuff
    
    //clear chart
    //remove all series
    //updatechartviews
    //set new series using calories from IntakeController.calories
    
    
    
    @objc func refreshViews(_ notification: Notification) {
        chart.removeAllSeries()
        intakeController.fetchAllIntakes()
        let series = ChartSeries(intakeController.calories)
        chart.add(series)
        tableView?.reloadData()
    }
    
    @IBAction func addIntakeButtonTapped(_ sender: Any) {
        //alert popup with a text field.
        //User enters calories
        //create new calorie intake
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        alert.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            guard let answer = alert.textFields?[0] else { return }
            //do something with "answer" here
            //create an intake and save it to core data.
            let calories = Double(answer.text ?? "0")
            self.intakeController.createIntake(with: calories ?? 0)
            do {
                try self.intakeController.saveToPersistentStore()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
            
            NotificationCenter.default.post(name: .intakeAdded, object: self)

        }
        alert.addAction(submit)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)

        let intake = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = String(intake.calories)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: intake.timeStamp ?? Date())
        cell.detailTextLabel?.text = dateString

        return cell
    }


    // MARK: = NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    
    // MARK: - Properties
    var intakeController = IntakeController()
    var chart = Chart(frame: CGRect.zero)
    
    lazy var fetchedResultsController: NSFetchedResultsController<Intake> = {
        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true), NSSortDescriptor(key: "calories", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timeStamp", cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
        
    }()
}

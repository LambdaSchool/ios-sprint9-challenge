//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Properties

    var chart: Chart?
    let notificationCneeter = NotificationCenter.default
    let calorieTrackerController = CalorieController()
    
    var data = [Double]()
    
    var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yyyy, h:mm a"
           formatter.timeZone = TimeZone.autoupdatingCurrent
           return formatter
       }
    
    let date = Date(timeIntervalSinceNow: 0)
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "date", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch  {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Actions

    @IBAction func addInput(_ sender: UIBarButtonItem) {
        // add alert Controller for inpt here
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configure the cell...

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
    
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
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
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
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default:
            return
        }
    }
}

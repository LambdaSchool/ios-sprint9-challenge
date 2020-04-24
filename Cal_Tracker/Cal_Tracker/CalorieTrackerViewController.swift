//
//  CalorieTrackerViewController.swift
//  Cal_Tracker
//
//  Created by Lydia Zhang on 4/24/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var calorieController = CalorieController()
    var scale: [Double] = []
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calorieTV.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Calorie: \(calorie.calorie)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.time ?? Date())
        return cell
    }
    
    @IBOutlet weak var chart: Chart!
    
    var chartView = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
    //chartView.add(series)
    
    
    @IBOutlet weak var calorieTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieTV.dataSource = self
        calorieTV.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTV.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTV.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            calorieTV.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            calorieTV.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            calorieTV.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieTV.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieTV.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            calorieTV.deleteRows(at: [fromIndexPath], with: .automatic)
            calorieTV.insertRows(at: [toIndexPath], with: .automatic)
        @unknown default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

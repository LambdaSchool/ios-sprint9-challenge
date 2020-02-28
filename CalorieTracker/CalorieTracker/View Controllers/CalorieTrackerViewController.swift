//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController, UITableViewDataSource {
    
    let calorieIntakeController = CalorieIntakeController()

    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "date", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var calorieTrackerTableView: UITableView!
    @IBOutlet weak var calorieIntakeTableViewCell: CalorieIntakeTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieTrackerTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func addCalorieIntakeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "Enter Calorie Amount:"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text {
                _ = CalorieIntake(calories: Int(calories) ?? 0, date: Date(), context: CoreDataStack.shared.mainContext)
                self.calorieIntakeController.saveToPersistentStore()
            }
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath) as? CalorieIntakeTableViewCell else { return UITableViewCell()}

        let calorieIntake = fetchedResultsController.object(at: indexPath)
        cell.intake = calorieIntake
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieIntake = fetchedResultsController.object(at: indexPath)
            calorieIntakeController.delete(for: calorieIntake)
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

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTrackerTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTrackerTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            calorieTrackerTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            calorieTrackerTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            calorieTrackerTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieTrackerTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            calorieTrackerTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            calorieTrackerTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieTrackerTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension CalorieTrackerViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
}

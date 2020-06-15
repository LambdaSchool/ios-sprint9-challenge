import UIKit
import Pods_Calorie_Tracker
import SwiftChart
import CoreData


class CaloriesTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var caloriesController = CaloriesController()
    
    
    // MARK: - NSFetchedObjectController
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calories> = {
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
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
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chart: Chart!
    
    
    // MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK: - Tableview Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntake", for: indexPath)
        let object = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(object.amount)"
        cell.detailTextLabel?.text = object.date?.string()
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let CalorieItem = fetchedResultsController.object(at: indexPath)
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(CalorieItem)
            
            do {
                try moc.save()
            } catch {
                moc.reset()
                print("Error saving deleted task: \(error)")
            }
        }
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        // Alert UI
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of Calories in the field", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            guard let textField = alert.textFields?.first,
                let caloriesToSave = Int16(textField.text!) else {
                    return print("Invalid Input")
            }
            
            let _ = Calories(amount: caloriesToSave)
            do {
                let moc = CoreDataStack.shared.mainContext
                try moc.save()
            } catch {
                print("Error saving task: \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
}


// MARK: - Extentions

extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
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
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

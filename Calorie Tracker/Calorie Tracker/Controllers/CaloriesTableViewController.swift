
import UIKit
import SwiftChart
import CoreData

extension NSNotification.Name {
    static let shouldShowChartDataChanged = NSNotification.Name("ShouldShowChartDataChanged")
}

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.chartSetUp()
            self.tableView.reloadData()
        }
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc func shouldShowChartDataChanged(_ notification: Notification) {
        
        clearChart()
        chartView.removeAllSeries()
        chartSetUp()
        tableView.reloadData()
    }
    
    // MARK: - Alert Controller

    @IBAction func addButton(_ sender: Any) {
        showInputPopUp()
    }
    
    func showInputPopUp() {
        
        // Create UIAlertController, set title and message
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)

        // Confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in

            // Get the input values from user
            let calories = alertController.textFields?[0].text
            let caloriesInt = Int16(calories ?? "0")

            // Put the user-entered amount into the caloriesInput property
            self.calorieInputController.createInput(calories: caloriesInt!, timestamp: Date())
            
            // Post a notification
            NotificationCenter.default.post(name: .shouldShowChartDataChanged, object: self)
            
            //self.data.append((self.data.count + 1, Double(caloriesInt!)))
            
//            self.newData.append((self.data.count + 1, Double(caloriesInt!)))
//
//            let newSeries = ChartSeries(data: self.newData)
//
//            newSeries.area = true
//            newSeries.color = ChartColors.cyanColor()
//
//            self.chartView.add(newSeries)
        }
        
        // Cancel action does nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        // Add textfield to popup
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }

        // Add action to popup
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        // Present the popup
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return calorieInputController.caloriesInput.count
        //return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        let calorieInput = calorieInputController.caloriesInput[indexPath.row]
        //let calorieInput = fetchedResultsController.object(at: indexPath)
 
        cell.textLabel?.text = "Calories: \(calorieInput.calories)"
        
        if calorieInput.formattedTimeStamp != nil {
           cell.detailTextLabel?.text = "\(calorieInput.formattedTimeStamp!)"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieInput = calorieInputController.caloriesInput[indexPath.row]
            //let calorieInput = fetchedResultsController.object(at: indexPath)
            
            // Delete the row from the data source
            calorieInputController.deleteInput(calorieInput: calorieInput)
            tableView.deleteRows(at: [indexPath], with: .fade)

            clearChart()
            chartView.removeAllSeries()
            chartSetUp()
            
            NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
        }
    }
    
    // MARK: - Chart
    
    func clearChart() {
        
        data = [(0, 0.0)]
        
    }
    
    func chartSetUp() {
        
        for input in calorieInputController.caloriesInput {
            if let input = input as? CalorieInput {
                data.append((data.count, Double(input.calories)))
            }
        }
        
        let series = ChartSeries(data: data)
        series.area = true
        
        series.color = ChartColors.cyanColor()
        chartView.add(series)
        
//        let caloriesDouble = Double(calorieInput.calories)
//        let series = ChartSeries([caloriesDouble])
        //let series = ChartSeries(calorieIntsForChart)
//        let initialSeries = ChartSeries([0.0, 0.0])
//        chartView.add(initialSeries)
//
//        let series = ChartSeries([calorieInput.calories])
    

//        chartView.add([(data.count + 1, caloriesInt)])
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    // React to when we hear about changes
    
    // Controller tells us something is about to change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Get the fetched results change type
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            // tell the table view to insert rows at this index path
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            // Make sure we have an index path
            guard let indexPath = indexPath else { return }
            // delete the row at that index path
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Properties
    
    // Array starts at 0 in order for chart to start at 0
    private var data: [(Int, Double)] = [(0, 0.0)]
    
    let calorieInputController = CalorieInputController()
    
    var calorieInput: CalorieInput!
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieInput> = {
        // Fetch request from CalorieInput object
        let fetchRequest: NSFetchRequest<CalorieInput> = CalorieInput.fetchRequest()
        
        // Sort descriptor sorts inputs based on identifier
        // Give sort descriptor to fetch request's sortDescriptor's property (an array of sort descriptors)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        // Adopt the NSFetchedResultsControllerDelegate Protocol
        frc.delegate = self
        
        // Perform the fetch request
        try? frc.performFetch()
        
        return frc
        
    }()
    
}

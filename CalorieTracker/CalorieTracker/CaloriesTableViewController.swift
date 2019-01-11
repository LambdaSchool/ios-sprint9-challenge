//
//  CaloriesTableViewController.swift
//  CalorieTracker
//
//  Created by Welinkton on 1/11/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController, ChartDelegate, NSFetchedResultsControllerDelegate {
  
    // set up FRC
    // set up FRC Delegate
    // set up chart
    // set up Alert
    // ? Set up notifications

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    // MARK: - Properties
    
    private let calorieIntakeController = CalorieIntakeController()
    private var swiftChart: Chart = Chart(frame: .zero)
    let reuseIdentifier = "CalorieCell"
    var dateFormatter: DateFormatter  {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        return formatter
    }
    

    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?.count ?? 0 // should be number of objects.. if I remember.
        
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
     
     let calorieIntake = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Caloric Intake: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(for: calorieIntake.date)
     
     return cell
     }
    

     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
    // UIAlert Controller
    @IBAction func addCalories(_ sender: Any) {
        
        // um... Alert Controller thing?
        
        let alert = UIAlertController(title: "Add", message: "How many Calories is this", preferredStyle: .alert)
        
        alert.addTextField { (TextField) in
            TextField.placeholder = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) in
                guard let textField = alert.textFields?.first,
                let caloriesString = textField.text else {return}
            
            let calories = Int16(caloriesString) ?? 0
            self.calorieIntakeController.add(calories: calories)
            
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ChartViewOutlet
    @IBOutlet weak var swiftChartView: UIView!
    
    
    // MARK: FRCDelegate
    
    /*
     Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
     subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
     with information from a managed object at the given index path in the fetched results controller.
     */
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
   
    // MARK: FRC
    
        var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    
     
     
     // MARK:  Chart Delegate - ?? Do I need this..
     
     func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
     
     }
     
     func didFinishTouchingChart(_ chart: Chart) {
    
     }
     
     func didEndTouchingChart(_ chart: Chart) {
    
     }
     
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

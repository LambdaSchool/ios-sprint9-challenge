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

class CaloriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
    // set up FRC
    // set up FRC Delegate
    // set up chart
    // set up Alert
    // ? Set up notifications

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Build Swiftchart and add to subview of chart
        
        let frame = CGRect(x: 0, y:0, width: swiftChartView.frame.width, height: swiftChartView.frame.height)
            chart = Chart(frame:frame)
            swiftChartView.addSubview(chart)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCalories), name: .updateCalories, object: nil)
        
        updateCalories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Properties
    
    private let calorieIntakeController = CalorieIntakeController()
    var chart = Chart()
    let reuseIdentifier = "CalorieCell"
    var dateFormatter: DateFormatter  {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
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
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0  // should be number of objects.. if I remember.
        
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
     
     let calorieIntake = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Caloric Intake: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(for: calorieIntake.date)
     
     return cell
     }
    
    
    // UIAlert Controller
    @IBAction func addCalories(_ sender: Any) {
        
        // um... Alert Controller thing?
        
        let alert = UIAlertController(title: "Add", message: "How many Calories would you like to log", preferredStyle: .alert)
        
        alert.addTextField { (TextField) in
            TextField.placeholder = "Calories:"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) in
                guard let textField = alert.textFields?.first,
                let caloriesString = textField.text else {return}
            
            let calories = Int16(caloriesString) ?? 0
            self.calorieIntakeController.add(calories: calories)
            
            // needs to be post.
            NotificationCenter.default.post( name: .updateCalories , object: nil)
            
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
        
         guard let newIndexPath = newIndexPath,
            let indexPath = indexPath else { return }
        
        switch type {
        case .insert :
            tableView.insertRows(at: [newIndexPath], with: .fade)
        
        case .delete:
            tableView.deleteRows(at: [newIndexPath], with: .fade)
        
        case .update:
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        
        case .move:
            tableView.insertRows(at: [newIndexPath], with: .fade)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
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
   
    // MARK: FRC
    
      lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        try! frc.performFetch()
        frc.delegate = self // why wasn't this working?!
        return frc
    }()
    
    
    // Mark: SwiftChartView
    
        // draw chart in chartView
        // add subView
        // set data
        // chart should respond to notification??
        // create an objc function
    
    @objc func updateCalories() {
        
        guard let caloricIntake = fetchedResultsController.fetchedObjects?.compactMap({ Double($0.calories) }) else { return }
        
        let series = ChartSeries(caloricIntake)
        series.area = true
        series.color = ChartColors.goldColor()
        chart.add(series)
        
    }
}

extension Notification.Name {
    static let updateCalories = Notification.Name("updateCalories")
}

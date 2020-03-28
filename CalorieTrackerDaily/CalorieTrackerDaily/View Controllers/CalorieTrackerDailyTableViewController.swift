//
//  CalorieTrackerDailyTableViewController.swift
//  CalorieTrackerDaily
//
//  Created by jkaunert on 2/15/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData
import Foundation

extension Notification.Name {
    static let calorieEntryAdded = Notification.Name("calorieEntryAdded")
}

class CalorieTrackerDailyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let reuseIdentifier = "CalorieEntryCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(calorieEntryAdded(_:)), name: .calorieEntryAdded, object: nil)
    }
    
    @objc func calorieEntryAdded(_ notification: Notification) {
        DispatchQueue.main.async {
            self.reloadChart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        reloadChart()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CalorieEntryTableViewCell
//
        // Configure the cell...
        let entry = fetchedResultsController.object(at: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm:ss a"
        let dateString = formatter.string(from: entry.date!)
       
        let caloriesString = String(entry.calories)
        cell.caloriesLabel.text = "Calories: \(caloriesString)"
        cell.timestampLabel.text = "\(dateString)"


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - FetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTrackerEntry> = {
        let fetchRequest: NSFetchRequest<CalorieTrackerEntry> = CalorieTrackerEntry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        return frc
        
    }()
    
    
    // Delegate Methods
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
            guard let indexPath = newIndexPath else {return}
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath else {return}
            guard let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
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

    // MARK: - Properties

    let moc = CoreDataStack.shared.mainContext
    
    var calorieTrackerEntries: [CalorieTrackerEntry] = []
    var seriesValues: [Double] = []

    
    
    
    
    
    @IBAction func addEntry(_ sender: UIBarButtonItem) {
        let addEntryAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below.", preferredStyle: .alert)
        addEntryAlert.addTextField { (calorieInputTextField) in
            calorieInputTextField.placeholder = "Enter Calories: "
        }
        addEntryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))
        addEntryAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            [unowned self] action in
            //TODO: - handle submit entry
            guard let textField = addEntryAlert.textFields?.first, let caloriesToSave = textField.text else { return }
            let newEntry = CalorieTrackerEntry(calories: Int32(caloriesToSave) ?? 0, context: self.moc)
            self.calorieTrackerEntries.append(newEntry)
            
            self.seriesValues.append(Double(caloriesToSave)!)
            self.calorieChart.series = [ChartSeries(self.seriesValues)]
            try? CoreDataStack.shared.save(context: self.moc)
            
            NotificationCenter.default.post(name: .calorieEntryAdded, object: self)
            
                        
        }))
        
        self.present(addEntryAlert, animated: true)
    }
    
    func reloadChart() {
        guard let num = fetchedResultsController.fetchedObjects?.count else {return}
        var seriesTemp: [Double] = []
        calorieChart.removeAllSeries()
        for i in 0..<num {
            seriesTemp.append(Double(fetchedResultsController.fetchedObjects?[i].calories ?? 0))
        }
        seriesValues = seriesTemp
        let series = ChartSeries(seriesValues)
        series.area = true
        series.colors = (above: ChartColors.cyanColor(), below: .white, zeroLevel: 0)
        
        calorieChart.add(series)
        self.calorieChart.setNeedsDisplay()
    }
    
    @IBOutlet weak var calorieChart: Chart!

    
}

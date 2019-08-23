//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Sean Acres on 8/23/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<CaloriesEntry> = {
        let fetchRequest: NSFetchRequest<CaloriesEntry> = CaloriesEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()

    let calorieController = CalorieController()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }
    
    @IBOutlet weak var calorieChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addCalories(_ sender: Any) {
        presentCalorieInput()
    }
    
    private func setUpChart() {
        var amounts: [Double] = []
        
        guard let calorieEntries = fetchedResultsController.fetchedObjects else { return }

        for entry in calorieEntries {
            amounts.append(entry.amount)
        }
        
        let chartSeries = ChartSeries(amounts)
        calorieChart.add(chartSeries)
    }
    
    private func presentCalorieInput() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            if let amount = alert?.textFields![0].text {
                self.calorieController.createCaloriesEntry(amount: amount)
            }
        }))
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorieEntry = fetchedResultsController.object(at: indexPath)
        
        guard let timestamp = calorieEntry.timestamp else {
            return UITableViewCell() }
        
        cell.textLabel?.text = "Calories: \(calorieEntry.amount)"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)

        return cell
    }


}

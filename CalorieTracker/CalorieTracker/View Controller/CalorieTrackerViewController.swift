//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Christopher Aronson on 6/21/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    @IBOutlet var chartView: Chart!
    @IBOutlet var tableView: UITableView!
    
    var chartData = [Double]()
    
    var calorieTrackerController = CalorieTrackerController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Could not fetch data. In fetchedResultsController -> EntriesTableViewController: \(error)")
        }
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        for calories in fetchedResultsController.fetchedObjects as! [CalorieTracker] {
            chartData.append(Double(calories.calories))
        }
        
        let series = ChartSeries(chartData)
        chartView.add(series)
    }


    @IBAction func addCalloriesToTrackerTapped(_ sender: Any) {
        let ac = UIAlertController(title: "How many Calories would you like to add?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let caloriesString = ac.textFields?.first?.text,
            let calories = Int16(caloriesString)
            else { return }
            
            self.calorieTrackerController.create(calories: calories, timestamp: Date(), context: CoreDataStack.shared.mainContext)
            
            self.chartData.append(Double(calories))
            let series = ChartSeries(self.chartData)
            self.chartView.add(series)
        }))
        
        present(ac, animated: true)
        
    }
}

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let caloriesForThisCell = fetchedResultsController.object(at: indexPath)
        guard let timestamp = caloriesForThisCell.timestamp else { return cell }
        
        cell.textLabel?.text = "\(caloriesForThisCell.calories)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
}

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    
}

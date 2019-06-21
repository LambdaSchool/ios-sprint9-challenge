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
    
    var caloriesEntered: Int16 = 0
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(caloriesAdded), name: NSNotification.Name("CalloriesAdded"), object: nil)
        
        updateViews()
    }


    @IBAction func addCalloriesToTrackerTapped(_ sender: Any) {
        let ac = UIAlertController(title: "How many Calories would you like to add?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let caloriesString = ac.textFields?.first?.text,
            let calories = Int16(caloriesString)
            else { return }
            
            self.caloriesEntered = calories
            
            self.calorieTrackerController.create(calories: calories, timestamp: Date(), context: CoreDataStack.shared.mainContext)
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: NSNotification.Name("CalloriesAdded"), object: self)
        }))
        
        present(ac, animated: true)
        
    }
    
    func updateViews() {
        chartData.removeAll()
        
        for calories in fetchedResultsController.fetchedObjects as! [CalorieTracker] {
            chartData.append(Double(calories.calories))
        }
        
        if caloriesEntered != 0 {
            chartData.append(Double(caloriesEntered))
        }
        
        let series = ChartSeries(chartData)
        chartView.add(series)
    }
    
    @objc func caloriesAdded() {
        updateViews()
    }
}



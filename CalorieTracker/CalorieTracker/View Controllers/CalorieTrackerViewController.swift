//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Craig Swanson on 2/23/20.
//  Copyright © 2020 Craig Swanson. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    // MARK: - Properties
    var calorieTrackerController = CalorieTrackerController()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error in fetched results controller \(error)")
            fatalError("Error in fetched results controller \(error)")
        }
        return frc
    }()

    // MARK: - Outlets
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Control Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // The observer specifically looks for a new CalorieTracker entry that the user entered into the alert controller
        // If a new entry is found, the observer calls updateViews(), which reloads the data and also calls initializeChart().
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .addedCalorieEntry, object: nil)
       
        updateViews()
    }

    // MARK: - New Entry UI Alert
    @IBAction func addNewCalorieEntry(_ sender: UIBarButtonItem) {
        // show alert to enter new calorie info.
        let alert = UIAlertController(title: "New Calorie Entry", message: "Add a new entry for calories consumed.", preferredStyle: .alert)
        
        // check for valid user entry when the Submit button is tapped
        // if entry is valid, call the addEntry method to add it to core data
        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
            guard textField.text != "" else { return }
            guard let calories = textField.text,
            let validEntry = Double(calories) else { return }
            let newCalorieTracker = CalorieTracker(calories: validEntry)
            self.calorieTrackerController.addEntry(entry: newCalorieTracker)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "EnterCalories"
        }
        alert.addAction(submit)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @objc func updateViews() {
        tableView.reloadData()
        initializeChart()
    }
    
    // Create chart using SwiftChart library
    // I was not able to do much with the x-axis of timestamps.
    func initializeChart() {
        chartView.delegate = self
        
        guard let calorieTrackerArray: [CalorieTracker] = fetchedResultsController.fetchedObjects else { return }
        
        var calorieData: [Double] = []
        var timeData: [Double] = []
        
        for entry in calorieTrackerArray {
            let calorieDatum = entry.calories
            calorieData.append(calorieDatum)
            
            guard let timeDatum = entry.timestamp else { return }
            let convertedTime: Double = timeDatum.timeIntervalSince1970
            timeData.append(convertedTime)
        }
        
        let series = ChartSeries(calorieData)
        series.area = true
        
        chartView.lineWidth = 0.5
        series.color = ChartColors.blueColor()
        chartView.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.yLabelsOnRightSide = true
        
        chartView.add(series)
    }
}

// MARK: - Table View Data Source
extension CalorieTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        let calories = String(entry.calories)
        cell.textLabel?.text = calories
        
        let entryTime = entry.timestamp
        cell.detailTextLabel?.text = Date.stringFormattedDate(from: entryTime!)
        
        return cell
    }
}

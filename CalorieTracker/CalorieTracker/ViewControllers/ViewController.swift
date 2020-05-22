//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import CoreData

let updateViewsKey = "co.shawnjames.updateViews"

class ViewController: UIViewController {
    // MARK: - Outlets & Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortByDate",
                                                         ascending: false)]
        let mainContext = CoreDataManager.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> ViewController in fetchedResultsController: \(error)")
        }
        return fetchedResultsController
    }()
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle & init's
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        populateChartWithCoreDataEntries()
        createObservers()
    }
    
    // just for practice
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions & Methods
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // presents an alert and the alert handles the rest of the action
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories", preferredStyle: .alert)
        var calorieTextField: UITextField!
        alert.addTextField { (textField) in
            calorieTextField = textField
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            // TODO: populate the graph here?
            guard let calories = calorieTextField.text, !calories.isEmpty, let caloriesInt64 = Int64(calories) else { return }
            let date = self.dateFormatter.string(from: Date())
            Entry(calorieAmount: caloriesInt64, timeStamp: date)
            do {
                try CoreDataManager.shared.mainContext.save()
            } catch {
                print("Error saving new entry to CoreData: \(error)")
            }
            NotificationCenter.default.post(name: Notification.Name(updateViewsKey), object: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func populateChartWithCoreDataEntries() {
        var chartData = [Double]()
        // reset chart
        chart.removeAllSeries()
        // repopulate chart
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching -> ViewController in fetchedResultsController: \(error)")
        }
        let coreDataEntries = fetchedResultsController.fetchedObjects! as [Entry]
        for entry in coreDataEntries.reversed() { chartData.append(Double(entry.calorieAmount)) }
        let series = ChartSeries(chartData)
        chart.add(series)
    }
    
    private func createObservers() {
        // tableView
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.populateChartWithCoreDataEntries),
                                               name: Notification.Name(updateViewsKey), object: nil)
        // chart
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadTableView),
                                               name: Notification.Name(updateViewsKey), object: nil)
    }

    @objc private func reloadTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TableView data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") else { fatalError() }
        cell.textLabel?.text = String(fetchedResultsController.object(at: indexPath).calorieAmount)
        cell.detailTextLabel?.text = fetchedResultsController.object(at: indexPath).timeStamp
        return cell
    }
    
}

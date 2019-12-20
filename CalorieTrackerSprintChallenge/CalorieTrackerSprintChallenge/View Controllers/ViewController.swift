//
//  ViewController.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    // MARK: - IBOutlets and Properties
    var entryController = CalorieEntryController()
    let df = DateFormatter()
    var series: ChartSeries?
    lazy var frc: NSFetchedResultsController<CalorieEntry> = {
        
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "timestamp",
                                             cacheName: nil)
        
        frc.delegate = self.calorieEntryTableView as? NSFetchedResultsControllerDelegate
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var calorieEntryTableView: UITableView!
    
    // MARK: - IBActions and Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryTableView.delegate = self
        calorieEntryTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .newEntry, object: nil)
    }
    
    @IBAction func addCalorieEntryTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Entry", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter Calorie Amount"
        }
        // TODO: - finish action after EntryController has been created
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let calorieAmount = alert.textFields?.first?.text,
                !calorieAmount.isEmpty else { return }
            self.entryController.createEntry(amount: calorieAmount, timestamp: Date())
            self.updateViews()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc func updateViews() {
        calorieEntryTableView.reloadData()
        calorieChart.reloadInputViews()
    }
    
}

// MARK: - ViewController Extensions
extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calorieEntryTableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = frc.object(at: indexPath)
        guard let timestamp = entry.timestamp else { return UITableViewCell() }
        df.dateStyle = .medium
        df.timeStyle = .short
        
        cell.textLabel?.text = entry.amount
        cell.detailTextLabel?.text = df.string(from: timestamp)
        
        return cell
    }
    
    
}

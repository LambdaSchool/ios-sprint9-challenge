//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Michael Stoffer on 9/14/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

extension Notification.Name {
    static var updateChart = Notification.Name("updateChart")
}

class CalorieTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true), NSSortDescriptor(key: "created", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        return frc
    }()

    @IBOutlet var ChartUIView: UIView!
    
    let calorieController = CalorieController()
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func updateChart(notification: Notification) {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 400, height: 250))
        var data: [Double] = []
        for calorie in fetchedResultsController.fetchedObjects! {
            print(calorie)
            data.append(Double(calorie.calories!) as! Double)
        }
        let series = ChartSeries(data)
        chart.add(series)
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        self.ChartUIView.addSubview(chart)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorie = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calorie.calories ?? "0")"
        
        cell.detailTextLabel?.text = calorie.date

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editingStyle == .delete {
                let calorie = self.fetchedResultsController.object(at: indexPath)
                self.calorieController.deleteCalorie(withCalorie: calorie)
                self.tableView.reloadData()
            }
        }
    }
 
    @IBAction func AddCalorieButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Calories:"
        }
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let calorieCount = firstTextField.text else { return }
            self.calorieController.createCalorie(withCalorieCount: calorieCount)
            NotificationCenter.default.post(name: .updateChart, object: self)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

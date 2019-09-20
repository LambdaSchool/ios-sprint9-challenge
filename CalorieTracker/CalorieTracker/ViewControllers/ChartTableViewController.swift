//
//  ChartTableViewController.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class ChartTableViewController: UITableViewController {

    @IBOutlet var chartView: UIView!
    let calorieController = CalorieController()
    lazy var fetchedRC: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let moodSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "dietLevel", ascending:  false)
        fetchRequest.sortDescriptors = [moodSortDescriptor]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dietLevel", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError()
        }
        return frc
    }()
    
    var chart: Chart?
    
    override func viewDidLoad() {
        
        chartSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChart(notification:)), name: .calorieEntryCreated, object: nil)
    }
    @IBAction func addCalorieIntakeTapped(_ sender: UIBarButtonItem) {
        alertViewSetup()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return fetchedRC.sections?[section].name.capitalized
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedRC.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchedRC.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath) as? CaloriesTableViewCell else {return UITableViewCell()}
        let user = fetchedRC.object(at: indexPath)
        cell.user = user
        return cell
    }
    private func caloriesEntryCreatedNotificationPost() {NotificationCenter.default.post(.init(name: .calorieEntryCreated))}
    
    private func alertViewSetup() {
        //create ui alert
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        //add a textfield
        alert.addTextField { (textfield) in
            textfield.placeholder = "Calories"}
        //add a submit action to the alert controller with a closure to do the following:
        //1) Add calories to the user in core data
        //2) Post a notification to the Notification Center, so an updated chart can be made
        //3) Reload the tableview
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (submitAction) in
            let textField = alert.textFields![0]
            guard  let caloriesString = textField.text,
                let calories = Double(caloriesString) else {return}
            let time = Date()
            self.calorieController.addCaloriesToUser(calories: calories, timeStamp: time)
            self.caloriesEntryCreatedNotificationPost()}
        //Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshChart(notification: Notification) {
        chartSetup()
    }
     func chartSetup() {
        chart?.removeFromSuperview()
         chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
         guard let chart = chart else {return}
        guard let calorieEntries = fetchedRC.fetchedObjects else {return}
         var data: [Double] = []
        for calorieEntry in calorieEntries {
            let calories = calorieEntry.calories
            data.append(calories)
        }
        let series = ChartSeries(data)
        chart.add(series)
        chartView.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = chart.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 5)
        let leadingConstraint = chart.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 5)
        let trailingConstraint = chart.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 5)
        let bottomConstraint = chart.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 5)
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }
}

extension ChartTableViewController: NSFetchedResultsControllerDelegate {
}

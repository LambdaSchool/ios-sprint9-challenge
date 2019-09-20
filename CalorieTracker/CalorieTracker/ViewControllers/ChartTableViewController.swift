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
    
    
    lazy var fetchedRC: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let moodSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "dietLevel", ascending: true)
        fetchRequest.sortDescriptors = [moodSortDescriptor]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dietLevel", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        }catch {
            fatalError()
        }
        return frc
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartSetup()

    }
    
    
    @IBAction func addCalorieIntakeTapped(_ sender: UIBarButtonItem) {
        addCaloriesAlertViewSetup()
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
    
    
    private func addCaloriesAlertViewSetup() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Calories"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (submitAction) in
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func chartSetup() {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
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

//
//  CaloriesTableViewController.swift
//  CalorieTracker-SwiftChart
//
//  Created by Yvette Zhukovsky on 1/11/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData




class CaloriesTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {

   lazy var fetchedRC: NSFetchedResultsController<Calories> = {
        
        let fetchRequest: NSFetchRequest<Calories> = Calories.fetchRequest()
        let sortDescriptor = [NSSortDescriptor(key: "timestamp", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CaloriesAdded), name: .CaloriesAdded, object: nil)
        
        let frame = CGRect(x: 0, y: 0,
                           width: view.frame.width, height: chartViews.frame.height)
        chart = Chart(frame: frame)
        chartViews.addSubview(chart)
        CaloriesAdded()
 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func CaloriesAdded(){
        guard let number = fetchedRC.fetchedObjects?.compactMap({ Double($0.number) }) else { return }
        let series = ChartSeries(number)
        series.color = ChartColors.greenColor()
        series.area = true
        chart.add(series)
        
    }
  
  var chart = Chart()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedRC.sections?.count ?? 1
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chart.setNeedsDisplay()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedRC.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let calories = fetchedRC.object(at: indexPath)
        let number = String(calories.number)
        let timestamp = dateFormatter.string(from: calories.timestamp ?? Date())
        
        cell.textLabel?.text = "Calories: \(number)"
        cell.detailTextLabel?.text = timestamp
        
        return cell
    }
    

    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calories intake", message: "Enter the amount of calories in field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Submit", style: .default) { (submit) in
            guard let numberCalorie = alert.textFields?.first?.text,
                !numberCalorie.isEmpty else { return }
            self.caloriesController.addCalorie(number: Int(numberCalorie) ?? 0)
            NotificationCenter.default.post(name: .CaloriesAdded, object: nil)
            self.tableView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(submit)
        present(alert, animated: true, completion: nil)
       self.tableView.reloadData()
        
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    var caloriesController = CaloriesController()
    
    @IBOutlet weak var chartViews: UIView!
    
}


extension NSNotification.Name {
    static let CaloriesAdded = NSNotification.Name("CaloriesAdded")
}



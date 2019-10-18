//
//  ChartTableViewController.swift
//  Calorie Tracker
//
//  Created by Jordan Christensen on 10/19/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    return formatter
}()

class ChartTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet private weak var chart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    let controller = CalorieController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = frcRefetch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateViews()
        
        self.observeShouldUpdateViews()
    }
    
    private func observeShouldUpdateViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(_:)), name: .didAddCalorie, object: nil)
    }
    
    @objc
    private func refreshViews(_ notification: Notification) {
        updateViews()
    }
    
    private func updateViews() {
        fetchedResultsController = frcRefetch()
        
        tableView?.reloadData()
        
        guard let fetchedCalories = fetchedResultsController.fetchedObjects else { return }
        var cals: [Double] = []
        for i in fetchedCalories {
            cals.append(i.calories)
        }
        
        let series = ChartSeries(cals)
        series.color = ChartColors.greenColor()
        chart.removeAllSeries()
        chart.add(series)
        
    }
    
    private func frcRefetch() -> NSFetchedResultsController<Calorie> {
            let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true),
                                            NSSortDescriptor(key: "calories", ascending: true)]
        
            let moc = CoreDataStack.shared.mainContext
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        
            frc.delegate = self
                
            do {
                try frc.performFetch()
            } catch {
                NSLog("Problem fetching entities from CoreData: \(error)")
            }
    
            return frc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cals = fetchedResultsController.fetchedObjects else { return 0 }
        return cals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        guard var cals = fetchedResultsController.fetchedObjects else { return UITableViewCell() }
        let calorie = cals[indexPath.row]
        
        cell.textLabel?.text = "\(calorie.calories)"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: calorie.timestamp ?? Date()))"
        return cell
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let alert = alert,
                let textFields = alert.textFields,
                let text = textFields[0].text else { return }
            
            print("Text field: \(text)")
            
            if let num = Double(text) {
                self.controller.createCalorie(with: num)
            } else {
                let errorAlert = UIAlertController(title: "Calorie Intake Must be a Number!",
                                                   message: "It looks like you have entered an invalid format. Try again.",
                                                   preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

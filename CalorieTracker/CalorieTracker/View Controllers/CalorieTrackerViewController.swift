//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Kat Milton on 8/23/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var calorieTableView: UITableView!
    @IBOutlet var calorieChart: Chart!

    var calorieCountController = CalorieCountController()
    let dateFormatter = DateFormatter()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieCount> = {
        let fetchRequest: NSFetchRequest<CalorieCount> = CalorieCount.fetchRequest()
        
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [dateDescriptor]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "date", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch: \(error)")
        }
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calorieTableView.delegate = self
        self.calorieTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.calorieTableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
        
        var calorieCountTextField: UITextField!
        alert.addTextField { (textField) in
            textField.placeholder = ""
            calorieCountTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let calorieCount = calorieCountTextField.text ?? "0"
            
            self.calorieCountController.createEntry(with: calorieCount)
            
            DispatchQueue.main.async {
                self.calorieTableView.reloadData()
            }
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if let date = entry.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        cell.textLabel?.text = entry.intakeNumber
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            calorieCountController.deleteEntry(calorieCount: entry)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

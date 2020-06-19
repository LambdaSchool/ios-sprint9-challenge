//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Dahna on 6/19/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CalorieInput> = {
        let fetchRequest: NSFetchRequest<CalorieInput> = CalorieInput.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let mainContext = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching calorie intake: \(error)")
        }
        return frc
    }()
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextField: UITextField!
        alert.addTextField { textField in
            calorieTextField = textField
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            guard let calories = calorieTextField.text,
                !calories.isEmpty,
                let caloriesInt = Int(calories) else { return }
            
            CalorieInput(calories: caloriesInt)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving calorie submission: \(error)")
            }
            //            NotificationCenter.default.post(name: Notification.Name(self.updateViewsKey), object: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell") else { fatalError("Can't dequeue cell")}
        cell.textLabel?.text = String(fetchedResultsController.object(at: indexPath).calories)
        cell.detailTextLabel?.text = fetchedResultsController.object(at: indexPath).date?.stringDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 1
    }
}


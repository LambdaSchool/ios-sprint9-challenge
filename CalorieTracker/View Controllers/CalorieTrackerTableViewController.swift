//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Nonye on 6/19/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorieData = fetchedResultsController.object(at: indexPath)
        let calories = calorieData.calories
        let timestamp = calorieData.calorieDate ?? Date()
        
        cell.textLabel?.text = "Calories: \(Int(calories))"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieData = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            do {
                context.delete(calorieData)
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(Notification(name: .calorieAddedNotificationKey, object: nil))
            } catch {
                context.reset()
                print("Error deleting object from managed object context: \(error)")
            }
        }
    }
}

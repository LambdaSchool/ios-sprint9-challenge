//
//  CalorieTrackerViewControllerExtensions.swift
//  CalorieTracker
//
//  Created by Christopher Aronson on 6/21/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreData

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let caloriesForThisCell = fetchedResultsController.object(at: indexPath)
        guard let timestamp = caloriesForThisCell.timestamp else { return cell }
        
        cell.textLabel?.text = "\(caloriesForThisCell.calories)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
}

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    
}

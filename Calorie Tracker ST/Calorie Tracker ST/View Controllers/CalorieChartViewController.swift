//
//  CalorieChartViewController.swift
//  Calorie Tracker ST
//
//  Created by Jake Connerly on 10/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class CalorieChartViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

// MARK: - Extensions

extension CalorieChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = EntryController.entries[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(entry.calories)"
        if let date = entry.dateEntered {
            let dateString = "\(date)"
            let formattedDate = dateFormatter.date(from: dateString)
            cell.detailTextLabel?.text = "\(formattedDate)"
        }
        return cell
    }
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Kobe McKee on 6/28/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let calorieLogController = CalorieLogController()

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    
    
    
    // MARK: - TableView Data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieLogController.calorieLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let log = calorieLogController.calorieLogs[indexPath.row]
        
        cell.textLabel?.text = ("Calories: \(log.calories)")
        
        return cell
    }
    


}

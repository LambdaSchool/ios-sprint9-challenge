//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Hunter Oppel on 5/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Add Calories to Table View
    
    
}

// MARK: - Table View Extension

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

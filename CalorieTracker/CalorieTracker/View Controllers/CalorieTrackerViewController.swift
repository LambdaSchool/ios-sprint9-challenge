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
        // Do any additional setup after loading the view.
    }
}

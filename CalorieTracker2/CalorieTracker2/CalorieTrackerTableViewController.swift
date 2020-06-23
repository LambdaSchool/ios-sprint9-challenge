//
//  CalorieTrackerViewController.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

class CalorieTrackerViewController: UITableViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    @IBOutlet weak var caloriesTableView: UITableView!
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var timestampTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CalorieTrackerViewController

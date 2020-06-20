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

class CalorieTrackerViewController: UIViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    @IBOutlet weak var caloriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caloriesTableView.dataSource = self
        caloriesTableView.delegate = self
    }
    
}

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
}

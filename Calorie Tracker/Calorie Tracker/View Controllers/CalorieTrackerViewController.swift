//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Wyatt Harrell on 4/24/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    

}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

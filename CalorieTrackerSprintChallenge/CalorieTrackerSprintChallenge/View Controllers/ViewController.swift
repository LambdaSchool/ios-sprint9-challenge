//
//  ViewController.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    @IBOutlet weak var calorieChart: Chart!
    @IBOutlet weak var calorieEntryTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCalorieEntryTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Entry", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Calorie Amount"
        }
        // TODO: - finish action after EntryController has been created
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            <#code#>
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

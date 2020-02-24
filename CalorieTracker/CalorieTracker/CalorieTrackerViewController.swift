//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Craig Swanson on 2/23/20.
//  Copyright © 2020 Craig Swanson. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {
    
    var calorieTrackerController = CalorieTrackerController()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addNewCalorieEntry(_ sender: UIBarButtonItem) {
        // show alert
        // check for valid user entry
        // call add action with text field contents
        // dismiss alert
    }
}

// MARK: Table View Data Source
extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieTrackerController.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        return cell
    }
    
    
}

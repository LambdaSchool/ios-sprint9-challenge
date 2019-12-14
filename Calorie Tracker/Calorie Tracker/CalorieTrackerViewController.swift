//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let calorieEntryController = CalorieEntryController()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieEntryController.fetchCalorieEntries { (_) in
            tableView.reloadData()
        }
    }
    @IBAction func addCalorieEntryButtonTapped(_ sender: Any) {
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.entries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
            as? CalorieTableViewCell else { return UITableViewCell() }
        let entries = calorieEntryController.entries
        for entry in entries {
            cell.calories.text = "\(entry.calories)"
            cell.timestamp.text = "\(entry.timestamp ?? Date())"
        }
        return cell
    }
}

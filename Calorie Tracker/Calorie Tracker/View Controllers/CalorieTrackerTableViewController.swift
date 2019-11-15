//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Jesse Ruiz on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieLog", for: indexPath)

        return cell
    }
}

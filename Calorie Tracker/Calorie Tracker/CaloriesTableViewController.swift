//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by Karen Rodriguez on 4/24/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
class CaloriesTableViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet weak var chartUIView: Chart!

    let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])

    override func viewDidLoad() {
        super.viewDidLoad()
        series.area = true
        chartUIView.add(series)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}

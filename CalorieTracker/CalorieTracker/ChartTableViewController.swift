//
//  ChartTableViewController.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import UIKit
import SwiftChart

class ChartTableViewController: UITableViewController {

    @IBOutlet var chartView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chartSetup()
    }

    private func chartSetup() {
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chart.add(series)
        chartView.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = chart.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 5)
        let leadingConstraint = chart.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 5)
        let trailingConstraint = chart.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 5)
        let bottomConstraint = chart.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 5)
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }
    // MARK: - Table view data source

    @IBAction func addCalorieIntakeTapped(_ sender: UIBarButtonItem) {
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

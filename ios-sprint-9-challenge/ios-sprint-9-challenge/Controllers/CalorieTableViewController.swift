//
//  CalorieTableViewController.swift
//  ios-sprint-9-challenge
//
//  Created by David Doswell on 9/21/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

import UIKit
import SwiftChart

private let reuseIdentifier = "reuseIdentifier"

struct Calorie {
    let calories: String
    let timestamp: Date
}

class CalorieTableViewController: UITableViewController, UITextFieldDelegate {
    
    let calories : [Calorie] = []
    
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 420, height: 300))
    let data = [
        (x: 0, y: 0),
        (x: 3, y: 2.5),
        (x: 4, y: 2),
        (x: 5, y: 2.3),
        (x: 7, y: 3),
        (x: 8, y: 2.2),
        (x: 9, y: 2.5)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        chartSeries()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func chartSeries() {
        let series = ChartSeries(data: self.data)
        series.area = true
        
        chart.xLabels = [0, 3, 6, 9, 12, 15, 18, 21, 24]
        chart.xLabelsFormatter = { String(Int(round($1))) + "h" }
        
        chart.add(series)
    }
    
    private func setUpViews() {
        view.backgroundColor = .white
        self.title = "Calorie Tracker"
        
        let right = UIButton(type: .custom)
        right.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        right.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTap(sender:)))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(chart)
        
    }
    
    @objc private func rightBarButtonTap(sender: UIButton) {
        let cell = CalorieCell()
        presentAddCalorieAlert(cell: cell)
    }
    
    private func presentAddCalorieAlert(cell: CalorieCell) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "calories"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfield = alert.textFields![0] as UITextField
            textfield.autocapitalizationType = .none
            
            cell.caloriesLabel.text = "Calories"
            cell.caloriesNumber.text = "\(String(describing: textfield.text))"
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            cell.timestampLabel.text = dateFormatter.string(from: date)
        }
        alert.addAction(cancel)
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CalorieCell

        return cell
    }
}

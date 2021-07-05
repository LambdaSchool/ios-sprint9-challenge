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
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Calories:"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let caloriesNumber: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
        chart.backgroundColor = .white
        
        updateChart()
        
        chart.add(series)
    }
    
    private func updateChart() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateChartAlert), name: Notification.Name(String.notificationName), object: nil)
    }
    
    @objc func updateChartAlert() {

        // TODO
//        caloriesNumber.text = chart.xLabels
    }
    
    @objc private func rightBarButtonTap(sender: UIButton) {
        let cell = UITableViewCell()
        presentAddCalorieAlert(cell: cell)
    }
    
    private func presentAddCalorieAlert(cell: UITableViewCell) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "calories"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textfield = alert.textFields![0] as UITextField
            textfield.autocapitalizationType = .none
            
            self.caloriesLabel.text = "Calories"
            self.caloriesNumber.text = "\(String(describing: textfield.text))"
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
            self.timestampLabel.text = dateFormatter.string(from: date)
            
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(String.notificationName), object: nil)
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
        
        return calories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
//        let calorie = calories[indexPath.row]
        
        // TODO
        return cell
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
        view.addSubview(caloriesLabel)
        view.addSubview(caloriesNumber)
        view.addSubview(timestampLabel)
    }
}

extension String {
    static var notificationName = "alert"
}

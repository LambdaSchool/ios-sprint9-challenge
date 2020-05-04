//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by David Wright on 5/3/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    var calorieDataPoints = [CalorieDataPoint]()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addCalorieDataPoint(_ sender: UIBarButtonItem) {
        showCalorieIntakeAlert()
    }
    
    private func showCalorieIntakeAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textFields = alert.textFields,
                let caloriesString = textFields[0].text,
                !caloriesString.isEmpty,
                let calories = Int(caloriesString) else { return }
            self.addCalorieDataPoint(calories: calories)
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addCalorieDataPoint(calories: Int) {
        let timestamp = Date()
        let calorieDataPoint = CalorieDataPoint(calories: calories, timestamp: timestamp)
        calorieDataPoints.append(calorieDataPoint)
        tableView.reloadData()
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieDataPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieDataPointCell", for: indexPath)
        let calories = calorieDataPoints[indexPath.row].calories
        let timestamp = calorieDataPoints[indexPath.row].timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a"
        
        cell.textLabel?.text = "Calories: \(calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    
}

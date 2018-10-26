//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {

    // MARK: - Properties
    let calorieDataController = CalorieDataController()
    var calorieChart: Chart!
    
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .updatedCalorieDataNotification , object: nil)
        
        headerView.backgroundColor = .white
        setupChart()
        updateChart()
    }

    // MARK: - Actions
    @IBAction func addCalorieData(_ sender: Any) {
        presentAddCalorieAlert()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalorieTrackerTableViewController {
            destinationVC.calorieDataController = calorieDataController
        }
    }
    
    // MARK: - Utility Methods
    private func presentAddCalorieAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories"
            
            calorieTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            if let calorieString = calorieTextField?.text, let calories = Double(calorieString) {
                self.calorieDataController.createCalorieData(calories: calories)
                self.calorieDataController.fetchData()
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    private func setupChart() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        calorieChart = Chart(frame: frame)
        calorieChart.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(calorieChart)
        
        let topConstraint = NSLayoutConstraint(item: calorieChart, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: calorieChart, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: calorieChart, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: calorieChart, attribute: .trailing, relatedBy: .equal, toItem: headerView, attribute: .trailing, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    @objc private func updateChart() {
        let data = calorieDataController.calorieDatas.map() { $0.calories }
        let series = ChartSeries(data)
        series.area = true
        calorieChart.add(series)
    }
}

extension Notification.Name {
    static let updatedCalorieDataNotification = Notification.Name("UpdatedCalorieDataNotification")
}

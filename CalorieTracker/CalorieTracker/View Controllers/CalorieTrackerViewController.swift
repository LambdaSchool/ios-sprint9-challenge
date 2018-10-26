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
    var currentPerson: Person?
    
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .updatedCalorieDataNotification , object: nil)
        
        headerView.backgroundColor = .white
        setPerson()
        setupChart()
        updateChart()
    }

    // MARK: - Actions
    @IBAction func addCalorieData(_ sender: Any) {
        presentAddCalorieAlert()
    }
    
    @IBAction func addPerson(_ sender: Any) {
        presentChangePersonAlert()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalorieTrackerTableViewController {
            destinationVC.calorieDataController = calorieDataController
        }
    }
    
    // MARK: - Utility Methods
    private func setPerson() {
        let people = calorieDataController.fetchPeople()
        if people.count < 1 {
            presentAddPersonAlert()
        } else if people.count == 1 {
            currentPerson = people.first
        } else {
            presentChangePersonAlert()
        }
        
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
        
        let people = calorieDataController.fetchPeople()
        for (index, person) in people.enumerated() {
            let data = calorieDataController.fetchCalories(for: person).map() { $0.calories }
            let series = ChartSeries(data)
            let colorIndex = index % ChartColors.colors.count
            series.color = ChartColors.colors[colorIndex]
            calorieChart.add(series)
        }
    }
    
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
            if let calorieString = calorieTextField?.text, let calories = Double(calorieString), let currentPerson = self.currentPerson {
                self.calorieDataController.createCalorieData(calories: calories, person: currentPerson)
                self.calorieDataController.fetchData()
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    private func presentAddPersonAlert() {
        let alert = UIAlertController(title: "Add Your Name", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your Name"
            
            nameTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            if let nameString = nameTextField?.text {
                let name = !nameString.isEmpty ? nameString : "Unknown Person"
                self.currentPerson = self.calorieDataController.createPerson(name: name)
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    private func presentChangePersonAlert() {
        let alert = UIAlertController(title: "Who Are You?", message: nil, preferredStyle: .actionSheet)
        
        let people = self.calorieDataController.fetchPeople()
        
        for person in people {
            let personAction = UIAlertAction(title: person.name, style: .default) { (_) in
                self.currentPerson = person
            }
            
            alert.addAction(personAction)
        }
        
        let newPersonAction = UIAlertAction(title: "Add New", style: .default) { (_) in
            self.presentAddPersonAlert()
        }
        alert.addAction(newPersonAction)
        
        present(alert, animated: true)
    }
}

extension Notification.Name {
    static let updatedCalorieDataNotification = Notification.Name("UpdatedCalorieDataNotification")
}

extension ChartColors {
    static var colors: [UIColor] {
        return [ChartColors.blueColor(), ChartColors.orangeColor(), ChartColors.greenColor(), ChartColors.redColor(), ChartColors.purpleColor(), ChartColors.maroonColor(), ChartColors.pinkColor(), ChartColors.greenColor(), ChartColors.cyanColor(), ChartColors.goldColor(), ChartColors.yellowColor()]
    }
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Sean Hendrix on 1/11/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
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
        
        // Add observer that will notify the main view controller when the data has been updated.
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .updatedCalorieDataNotification , object: nil)
        
        // Reset the backgroun of the headview (not really necessary, I just wanted to be able to see it in the storyboard.)
        headerView.backgroundColor = .white
        // Set the current person
        setPerson()
        // Set up the constraints for the chart
        setupChart()
        // Update the chart's data
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
    /// Sets the current person. If there are no people stored on this phone, it presents an alert to add one. If there is one person, it defaults to that person. If there are more than one it presents an action sheet so the user can choose.
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
    
    /// Sets up the constraints for the Chart. Ties it to the size of the header view
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
    
    /// Updates the chart with the currently available data
    @objc private func updateChart() {
        let people = calorieDataController.fetchPeople()
        // Loop through the people and make a series for their data, and add it to the chart.
        for (index, person) in people.enumerated() {
            let data = calorieDataController.fetchCalories(for: person).map() { $0.calories }
            let series = ChartSeries(data)
            let colorIndex = index % ChartColors.colors.count
            series.color = ChartColors.colors[colorIndex]
            calorieChart.add(series)
        }
    }
    
    /// Presents an alert for the user to add calories
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
                // Create a new calorie data entry
                self.calorieDataController.createCalorieData(calories: calories, person: currentPerson)
                // Notify the observers that the data has been updated.
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    /// Presents an alert for the user to add a new person
    private func presentAddPersonAlert() {
        let alert = UIAlertController(title: "Add Your Name", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your Name"
            
            nameTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            if let nameString = nameTextField?.text {
                // If the user didn't enter a name, make one for them.
                let name = !nameString.isEmpty ? nameString : "Unknown Person"
                // Set the current person to the newly created person.
                self.currentPerson = self.calorieDataController.createPerson(name: name)
                // Notify the observers that the data has been updated.
                NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
            }
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }
    
    /// Presents an action sheet for the user to choose a person.
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

// Extension on Notification name to prevent typos. In a real app, I would put this in its own file.
extension Notification.Name {
    static let updatedCalorieDataNotification = Notification.Name("UpdatedCalorieDataNotification")
}

// Extension on ChartColors to give an array of colors to loop through. If I had more time, I would probably organize this differntly, so that I could tie colors directly to a user, to be used in more than one place. And give the user the ability to set the color.
extension ChartColors {
    static var colors: [UIColor] {
        return [ChartColors.blueColor(), ChartColors.orangeColor(), ChartColors.greenColor(), ChartColors.redColor(), ChartColors.purpleColor(), ChartColors.maroonColor(), ChartColors.pinkColor(), ChartColors.greenColor(), ChartColors.cyanColor(), ChartColors.goldColor(), ChartColors.yellowColor()]
    }
}

//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Jonathan Ferrer on 6/28/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import SwiftChart
import NotchyAlert

class CalorieTableViewController: UITableViewController {


    @IBOutlet weak var chartView: Chart!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = .black
        setUpChart(with: mealController.meals)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .mealWasAdded, object: nil)
    }

    @objc func refreshData() {
        setUpChart(with: mealController.meals)
        tableView.reloadData()
        print(mealController.meals.count)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        alertWithTF()

    }
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealController.meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
        let meal = mealController.meals[indexPath.row]
        guard let timestamp = meal.timestamp else { return cell}

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")

        cell.caloriesLabel.text = "Calories: \(meal.calories)"
        cell.timestampLabel.text = "\(dateFormatter.string(from: timestamp))"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .gray
    }


    func alertWithTF() {
        let confirm = NotchyAlert(title: "Calorie Tracker", description: "Calories added to the chart", image: UIImage(named: "Confirmation"))
        let cancelNotch = NotchyAlert(title: "Calerie Tracker", description: "Calories were not added", image: UIImage(named: "Cancel"))
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the text field", preferredStyle: UIAlertController.Style.alert)
        let submit = UIAlertAction(title: "Submit", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                guard let caloriesText = textField.text,
                    let calories = Int(caloriesText) else { return }
                self.mealController.createMeal(calories: calories)
                confirm.presentNotchy(in: self.view, duration: 1, bounce: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
            cancelNotch.presentNotchy(in: self.view, duration: 1)
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Calories"
            textField.textColor = .red
        }
        
        alert.addAction(submit)
        alert.addAction(cancel)
        self.present(alert, animated:true, completion: nil)


    }
    func setUpChart(with meals: [Meal]) {
        chartView.removeAllSeries()
        var mealCalories: [Double] = []
        for meal in meals {

            mealCalories.append(Double(meal.calories))
        }

        let series = ChartSeries(mealCalories)
        series.area = true
        series.color = ChartColors.darkRedColor()
        chartView.axesColor = .black
        chartView.gridColor = .red
        chartView.labelColor = .white
        chartView.yLabelsFormatter = { String(Int($1)) + " Calories"}


        chartView.add(series)
    }

    let mealController = MealController()


}

//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Victor  on 6/21/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit
import Charts

extension Notification.Name {
    static let didSubmitCalorie = Notification.Name("didSubmitCalorie")
}

class CalorieTrackerTableViewController: UITableViewController {
    
    //MARK: Properties
    var calorieController = CalorieController()
    var dataEntries: [ChartDataEntry] = []
    
    @IBOutlet weak var calorieChart: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(submitButtonPressed(notificaiton:)), name: .didSubmitCalorie, object: nil)
    }
    
    @objc func submitButtonPressed(notificaiton: Notification) {
        print("submit")
        print(calorieController.calories)
        getChartData()
        tableView.reloadData()
    }
    
    func getChartData() {
        var values: [Double] = []
        for value in calorieController.calories {
            values.append(Double(value.amount))
        }
        setChart(values: values)
    }
    
    func setChart(values: [Double]) {
        calorieChart.noDataText = "No Data"
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let line1 = LineChartDataSet(entries: dataEntries, label: "Calorie")
        line1.colors = [NSUIColor.init(red: 113/255, green: 232/255, blue: 225/255, alpha: 1)]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        line1.valueTextColor = .clear
        let gradient = getGradientFilling()
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData()
        data.addDataSet(line1)
        calorieChart.data = data
        calorieChart.setScaleEnabled(false)
        calorieChart.animate(xAxisDuration: 1.0)
        calorieChart.legend.textColor = .white
        calorieChart.leftAxis.labelTextColor = .white
        calorieChart.rightAxis.drawAxisLineEnabled = false
        calorieChart.rightAxis.drawGridLinesEnabled = false
        calorieChart.rightAxis.enabled = false
        calorieChart.xAxis.drawLabelsEnabled = false
    }
    
    private func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 141/255, green: 133/255, blue: 220/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray
        let colorLocations: [CGFloat] = [0.7, 0.0]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.calories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as! CalorieTableViewCell
        
        let calorie = calorieController.calories[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorie.amount)"
        let myTimeInterval = TimeInterval(calorie.timeStamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        cell.detailTextLabel?.text = "\(time)"
        return cell
    }
    
    
    @IBAction func addCalorieIntakeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else {return}
            guard let amount = Int(textField.text!) else {
                print("not a valid number")
                return}
            let timestamp = NSDate().timeIntervalSince1970
            let calorie = Calorie(amount: amount, timeStamp: timestamp)
            self.calorieController.calories += [calorie]
            NotificationCenter.default.post(name: .didSubmitCalorie, object: Any?.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

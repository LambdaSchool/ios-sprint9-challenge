//
//  GraphViewController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//


import UIKit
import SwiftChart

class GraphViewController: UIViewController {
    
    let calorieTrackerController = CalorieTrackerController()
    //var entries: [CalorieEntry] = []
    
    @IBOutlet weak var chartView: UIView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    override func viewDidLoad() {
        if isViewLoaded {
            loadChart()
        } else {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadChart()
    }
    
    func loadChart() {
        for view in self.chartView.subviews{
            view.removeFromSuperview()
        }
        var chart: Chart = Chart()
        //entries = calorieTrackerController.entries
        //chart = Chart(frame: CGRect(x: 2, y: chartView.frame.height * 0.10, width: chartView.frame.width * 1.09, height: chartView.frame.height * 1.09))
        chart = Chart(frame: CGRect(x: 0,
                                    y: 0,
                                    width: chartView.frame.width,
                                    height: chartView.frame.height))
        //let arrayOfEntryCalories = calorieTrackerController.entries.map{ $0.calorie }
        let series = ChartSeries(calorieTrackerController.entries.map{ $0.calorie })
        series.area = true
        series.color = ChartColors.greenColor()
        chart.add(series)
        chartView.addSubview(chart)
    }
    
    
    func showAlert()
    {
        let alertController = UIAlertController(title: "Add Calorie Tracker", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        // TODO: Add the text field with handler
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
            print("Observe and Send Notification")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) in
            guard let textField = alertController.textFields?.first,
                let text = textField.text else {return}
            
            let calorie = Double(text) ?? 0
            self.calorieTrackerController.add(calorie: calorie)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("\nGraphViewController\nError attempting to save new entry:\n\(error)")
            }
            
            
            self.title = "Why are you being diffcult?"
            
            self.chartView.backgroundColor = .red
            //self.chart.removeFromSuperview()
            //self.chartView.removeFromSuperview()
            self.loadChart()
            NotificationCenter.default.post(name: .addCalorieEntry, object: nil)
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
}

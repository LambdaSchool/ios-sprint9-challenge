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
    var entries: [CalorieEntry] = []
    @IBOutlet weak var chartView: UIView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = calorieTrackerController.entries
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        let arrayOfEntryCalories = entries.map{ $0.calorie }
        let series = ChartSeries(arrayOfEntryCalories)
        chart.add(series)
        chartView.addSubview(chart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }

    private func updateViews() {
        // Update Chart Here...
    }
    
    func showAlert()
    {
        let alertController = UIAlertController(title: "Add Calorie Tracker", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        // TODO: Add the text field with handler
        alertController.addTextField { (textField) in
            print("Observe and Send Notification")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) in
            guard let textField = alertController.textFields?.first,
                let text = textField.text else {return}
            
            let calorie = Double(text) ?? 0
            //self.calorieTrackerController.entries.append(CalorieEntry(calorie: calorie))
            self.calorieTrackerController.add(calorie: calorie)
            
            
        
        })

        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
}

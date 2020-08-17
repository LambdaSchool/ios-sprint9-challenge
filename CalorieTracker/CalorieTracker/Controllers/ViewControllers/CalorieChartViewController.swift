//
//  CalorieChartViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/17/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieChartViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var calorieChartView: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Functionality Methods
    let calorieController = CalorieController()
    let calorieCell = "CalorieCell"
    
    let date: DateFormatter = {
        
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(configureUI), name: .caloriesCounted, object: nil)
    }
    
    @objc func configureUI() {
        var calorieCount: [Double] = []
        
        for calories in calorieController.caloriesRecorded {
            calorieCount.append(calories.caloriesRecorded)
        }
        
        calorieChartView.add(ChartSeries(calorieCount))
        tableView.reloadData()
    }
    
    @IBAction func addCalories(_ sender: UIBarButtonItem) {
        var caloriesInputTextField: UITextField?
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { textFieldSettings in
            textFieldSettings.placeholder = "Calories:"
            textFieldSettings.keyboardType = .numberPad
            caloriesInputTextField = textFieldSettings
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            
            guard let caloriesString = caloriesInputTextField?.text,
                let finalCalories = Double(caloriesString) else { return }
            self.calorieController.createEntry(calorieRecorded: finalCalories)
            NotificationCenter.default.post(name: .caloriesCounted, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension CalorieChartViewController: UITableViewDelegate {
    
}

extension CalorieChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.caloriesRecorded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: calorieCell, for: indexPath)
        let calorie = calorieController.caloriesRecorded[indexPath.row]
        cell.textLabel?.text = "Number of calories: \(Int(calorie.caloriesRecorded))"
        cell.detailTextLabel?.text = date.string(from: calorie.timeRecorded!)
        return cell
    }
    
    
}

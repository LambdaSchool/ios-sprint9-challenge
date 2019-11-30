//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CaloriesTableViewController: UITableViewController {
    
    // MARK: Properties
    var newCalorieString = ""
    let intakeController = IntakeController()
    var series: ChartSeries = ChartSeries([0.0, 0.0])
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChart()
        
        intakeController.fetchAllIntakes()
        tableView.reloadData()
        
    }
    
    // MARK: Add new Intake Alert
    @IBAction func addIntakeButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Calorie", message: "Enter New Calorie Amount", preferredStyle: .alert)
        
        let calorieAction = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
            
            // Getting textfield's text
            let amountTxt = alert.textFields![0]
            self.newCalorieString = amountTxt.text ?? ""
            
            self.intakeController.createIntake(calories: Int16(self.newCalorieString ?? "") ?? 0, context: CoreDataStack.shared.mainContext)
            
            
            NotificationCenter.default.post(name: .newIntake, object: self)
            self.updateViews()
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ( action) -> Void in })
        
        alert.addTextField(configurationHandler: { (textField: UITextField) in
            textField.placeholder = "Enter Calorie"
            textField.keyboardType = .default
        })
        
        alert.addAction(calorieAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func updateViews() {
        let caloriesDouble = intakeController.intakes.compactMap { Double($0.calories) }
        series = ChartSeries(caloriesDouble)
        
        tableView.reloadData()
    }
    
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .newIntake, object: nil)
    }
    
//    @objc private func addNewIntake() {
//
//    }
//
    
    
    
    
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return intakeController.intakes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as? CalorieTableViewCell else { return UITableViewCell() }
        
        cell.intake = intakeController.intakes[indexPath.row]


        return cell
    }
    
    
    func updateChart() {
        
        series.color = ChartColors.greenColor()
        chartView.add(series)
        
    }


}

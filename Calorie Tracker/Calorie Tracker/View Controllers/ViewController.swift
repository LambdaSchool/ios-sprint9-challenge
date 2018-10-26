//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Scott Bennett on 10/26/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController, ChartDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    var calories: [String] = ["200", "500", "340", "1000", "270", "832", "600"]
    let series = ChartSeries([200, 500, 340, 1000, 270, 832, 600])
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        chart.add(series)
    }
    
    
    @IBAction func addCalorie(_ sender: Any) {
        showInputDialog()

    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in field", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let inputCalories = alertController.textFields?[0].text else { return }
        
            self.calories.append(inputCalories)
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell")
        cell?.textLabel?.text = "Calories: \(calories[indexPath.row])"
        cell?.detailTextLabel?.text = formatter.string(from: Date())
        
        return cell!
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//
//  CalorieTVC.swift
//  sprint9-calorieTracker
//
//  Created by Nikita Thomas on 1/11/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTVC: UITableViewController {

    @IBOutlet weak var chart: Chart!
    
    var calorieEntries: [CalorieEntry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.backgroundColor = UIColor.white
        
        updateCalorieEntries()
        updateChart()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bananas")!)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 65)
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        
        textField.keyboardType = .numberPad
        
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        textField.layer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        vc.view.addSubview(textField)
        
        let alert = UIAlertController(title: "Add your calories", message: "Enter the amount of calories before you forget...", preferredStyle: .alert)
        let cancel =  UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (action) in
            print("Action")
            
            if let text = textField.text {
                if let caloricCount = Int(text) {
                    CalorieController.shared.saveEntry(withCalories: caloricCount)
                    
                    self.updateCalorieEntries()
                }
            }
        }
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(submit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func updateCalorieEntries() {
        CalorieController.shared.getEntries()
        
        var entryObjects: [CalorieEntry] = []
        
        for entry in CalorieController.shared.entries {
            let newEntryObject = CalorieEntry(calories: entry.value(forKey: "calories") as! Int, date: entry.value(forKey: "date") as! Date)
            
            entryObjects.append(newEntryObject)
        }
        
        self.calorieEntries = entryObjects
        updateChart()
    }
    
    func updateChart() {
        
        var data: [Double] = []
        
        for point in calorieEntries {
            data.append(Double(point.calories))
        }
        
        let series = ChartSeries(data)
        chart.add(series)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieEntries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calorieCell", for: indexPath)
        
        let entry = calorieEntries[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(entry.calories)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: entry.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }

}

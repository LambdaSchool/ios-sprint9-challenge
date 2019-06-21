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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(submitButtonPressed(notificaiton:)), name: .didSubmitCalorie, object: nil)
    }
    
    @objc func submitButtonPressed(notificaiton: Notification) {
        print("submit")
        print(calorieController.calories)
        tableView.reloadData()
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

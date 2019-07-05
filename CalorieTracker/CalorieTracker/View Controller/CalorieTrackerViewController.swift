//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 7/5/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {

    let calorieController = CalorieController()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func popUpToAddCalories(){
        let alert = UIAlertController(title: "Add Calorie Intake.", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        var myTextField: UITextField!
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add Calories"
            myTextField = textField
            guard let amountString = myTextField.text, !amountString.isEmpty, let amount = Int(amountString)  else { print("Error unwrapping alert textfield.") ; return }
            self.calorieController.addCalorie(with: amount)
        })
        
        let okAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            //TODO: ADD WHAT'S IN THE TEXT TO THE TABLEVIEW
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func addCalories(_ sender: UIBarButtonItem) {
        popUpToAddCalories()
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieController.calories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = calorieController.calories[indexPath.row]
        let calorieString = String(calorie.amount)
        cell.textLabel?.text = calorieString
        
        guard let calDate = calorie.date else { print("Error unwrapping date in cellForAtRow"); return UITableViewCell() }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        cell.detailTextLabel?.text = formatter.string(from: calDate)
        
        return cell
    }
    
    
}

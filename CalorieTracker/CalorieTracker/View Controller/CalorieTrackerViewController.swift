//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 7/5/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func popUpToAddCalories(){
        let alert = UIAlertController(title: "Add Calorie Intake.", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        var myTextField: UITextField!
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add Calories"
            myTextField = textField
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

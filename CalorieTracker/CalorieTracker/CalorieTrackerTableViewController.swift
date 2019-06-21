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

class CalorieTrackerTableViewController: UITableViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var addCalorieIntakeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCalorieIntakeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else {return}
            print(textField.text ?? "No Intake")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

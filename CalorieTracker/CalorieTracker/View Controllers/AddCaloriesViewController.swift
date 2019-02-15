//
//  AddCaloriesController.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class AddCaloriesViewController: UIViewController {
    
    

    @IBAction func doneButtonWasTapped(_ sender: Any) {
        
        guard let caloriesString = addCaloriesTextField.text else {return}
        let calories = caloriesString.convertToDouble()
        calorieIntakeController.calorieIntakesArray.append(CalorieIntake(calories: calories, timestamp: Date.init(), identifier: UUID.init().uuidString, insertInto: CoreDataStack.shared.mainContext))
        
        dismiss(animated: true)
        
    }
    
    var calorieIntakeController: CalorieIntakeController!
    
    @IBOutlet weak var addCaloriesTextField: UITextField!
}

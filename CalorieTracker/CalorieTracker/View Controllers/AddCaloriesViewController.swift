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
        CalorieIntakeController.shared.calorieIntakesArray.append(CalorieIntake(calories: calories, timestamp: Date.init(), identifier: UUID.init().uuidString, insertInto: CoreDataStack.shared.mainContext))
        CalorieIntakeController.shared.saveToPersistentStore(context: CoreDataStack.shared.mainContext)
        
        dismiss(animated: true)
        
    }
    
    @IBOutlet weak var addCaloriesTextField: UITextField!
}

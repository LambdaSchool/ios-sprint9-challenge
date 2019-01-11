//
//  NewCalorieIntakeView.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit

class NewCalorieIntakeView: UIView, UITextFieldDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calorieSourceTextField.delegate = self
        calorieSourceTextField.becomeFirstResponder()
    }
    
    @IBAction func addCaloriesButtonPressed(_ sender: Any) {
        
        guard let name = calorieSourceTextField.text,
            let stringAmount = calorieAmountTextField.text,
            let cgAmount = NumberFormatter().number(from: stringAmount) else { return }
        
        let amount = CGFloat(cgAmount)
        
        CalorieIntakeController.shared.newCalorieIntake(name: name, amount: amount)
        newCalorieIntakePopover.dismiss()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        calorieAmountTextField.becomeFirstResponder()
        return true
    }
    
    @IBOutlet weak var calorieSourceTextField: UITextField!
    @IBOutlet weak var calorieAmountTextField: UITextField!

}

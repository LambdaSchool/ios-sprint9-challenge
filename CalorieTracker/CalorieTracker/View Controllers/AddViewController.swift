//
//  AddViewController.swift
//  CalorieTracker
//
//  Created by Madison Waters on 2/16/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var AddValueTextField: UITextField!
    
    @IBAction func AddValue(_ sender: Any) {
        
        updateViews()
        dismiss(animated: true) { }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true) { }
    }
    
    func updateViews() {
        
        guard let calorieInput = AddValueTextField.text else { return }
        calorieController?.addCalorie(calorie: calorieInput)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var calorie: Calorie? {
        didSet {
            updateViews()
        }
    }
    
    var calorieController: CalorieController?
}

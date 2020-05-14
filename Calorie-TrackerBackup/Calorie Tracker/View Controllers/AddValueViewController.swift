//
//  AddValueViewController.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 2/15/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import UIKit

class AddValueViewController: UIViewController {

    @IBOutlet weak var addValueTextField: UITextField!
    
    @IBAction func addValueButton(_ sender: Any) {
        guard let calorie = calorie else { return }
        calorieController?.addCalorie(calorie: calorie)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var calorie: Calorie?
    var calorieController: CalorieController?
}

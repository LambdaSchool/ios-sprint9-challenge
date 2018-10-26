//
//  PopOverViewController.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/26/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet weak var addCalorieValueTextField: UITextField!
    
    @IBAction func submitValueButtonTapped(_ sender: Any) {
        updateViews()
    }
    
    @IBAction func cancelSegueButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let popOverView = UIView()
        view.addSubview(popOverView)
        popOverView.alpha = 10
        
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        
        // add calorie value to data Array
        addCalorieValueTextField.text = .calorie(let )
        data.append(
        
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum Calorie{
        case calorie(Int)
    }
    
    let data: [Int] = []
    let viewController = ViewController()
}

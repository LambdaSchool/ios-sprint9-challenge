//
//  MainTableViewController.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    
    
    @objc func addTapped() {
        showAlert()
    }
    
    
    
    func showAlert() {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }


}


//
//  ViewController.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension NSNotification.Name
{
    static let newEntryWasCreated = NSNotification.Name("NewEntryWasCreated")
}

class MainViewController: UIViewController
{
    let calorieController = CalorieController()
    
    lazy var caloriesTableViewController: CaloriesTableViewController =
    {
        let ctvc = CaloriesTableViewController()
        ctvc.calorieController = self.calorieController
        
        return ctvc
    }()
    
    lazy var caloriesGraphViewController: CaloriesGraphViewController =
    {
        let cgvc = CaloriesGraphViewController()
//        cgvc.calorieController = self.calorieController
        
        return cgvc
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupViews()
        
        calorieController.fetch {
            DispatchQueue.main.async {
                self.caloriesTableViewController.tableView.reloadData()
                self.caloriesGraphViewController.calorieController = self.calorieController
            }
        }
    }
    
    private func setupNavBar()
    {
        title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNewCalorie))
    }
    
    @objc private func handleAddNewCalorie()
    {
        var calorieTextField: UITextField?
        let alert = UIAlertController(title: "Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
            textField.placeholder = "Calories..."
            textField.keyboardType = .decimalPad
            calorieTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            
            guard let amount = calorieTextField?.text else { return }
            self.createNewCalorie(with: amount)
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func createNewCalorie(with amount: String)
    {
        guard let calories = Int(amount) else { return }
        let date = Date()
        let intDate = Int(Date().timeIntervalSince1970)
        let id = UUID().uuidString
        
        FirebaseManager.shared.uploadToDatabase(id: id, calories: calories, date: intDate) { (error) in
            
            if let error = error
            {
                self.showAlert(with: "There was an error saving your entry, please try again!")
                NSLog("Error uploading: \(error)")
                return
            }
            
            self.calorieController.createNewCalorieEntry(calories: Int16(calories), id: id, date: date)
        }
    }
    
    private func setupViews()
    {
        view.addSubview(caloriesGraphViewController.view)
        view.addSubview(caloriesTableViewController.view)
        
        caloriesGraphViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 160, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 200)
        
        caloriesTableViewController.view.anchor(top: caloriesGraphViewController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
}



















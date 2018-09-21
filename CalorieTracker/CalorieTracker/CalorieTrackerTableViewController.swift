//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Carolyn Lea on 9/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

extension NSNotification.Name
{
    static let shouldUpdateCell = NSNotification.Name("ShoudUpdateCell")
}

class CalorieTrackerTableViewController: UITableViewController
{
    var calorie: Calorie?
    var caloriesController = CaloriesController()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(shouldUpdateCell(_:)), name: .shouldUpdateCell, object: nil)
    }

    @objc func shouldUpdateCell(_ notification: Notification)
    {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return caloriesController.calories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let calorie = caloriesController.calories[indexPath.row]
        cell.textLabel?.text = calorie.calorieAmount
        
        let currentDate = calorie.timestamp
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
        let dateString = dateFormatter.string(from: currentDate!)
        
        cell.detailTextLabel?.text = dateString
        return cell
    }
 
    @IBAction func addNewRecord(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter calorie amount", preferredStyle: .alert)
        
        var calorieTextfield: UITextField?
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
            calorieTextfield = textField
        }
        
        let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            
            guard let calorie = calorieTextfield?.text else {return}
            let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
            
            self.caloriesController.createCalorieEntry(calorieAmount: calorie, context: backgroundMoc)
            let nc = NotificationCenter.default
            nc.post(name: .shouldUpdateCell, object: self)
            
            print("\(calorie)")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let backgroundMoc = CoreDataStack.shared.container.newBackgroundContext()
            let calorie = caloriesController.calories[indexPath.row]
            //let calorie = fetchedResultsController.object(at: indexPath)
            caloriesController.deleteCalorieEntry(calorie: calorie, context: backgroundMoc)
            tableView.reloadData()
        }
    }
    


}

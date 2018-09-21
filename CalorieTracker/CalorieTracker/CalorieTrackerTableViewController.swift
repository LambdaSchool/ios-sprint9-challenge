//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Carolyn Lea on 9/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewController: UITableViewController
{

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        // Configure the cell...

        return cell
    }
 
    @IBAction func addNewRecord(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter calorie amount", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = ""
        }
        let saveAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { alert -> Void in
            //let firstTextField = alertController.textFields![0] as UITextField
            print("submitted")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            print("canceled")
        })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    


}

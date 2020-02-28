//
//  ChartTableViewController.swift
//  CalorieTrackerSprint
//
//  Created by Jorge Alvarez on 2/28/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class ChartTableViewController: UITableViewController {
    
    // Bad way of doing this
    var calorieIntakeArray: [CalorieIntake] {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching calorieIntakes: \(error)")
            return []
        }
    }
    
    fileprivate lazy var alertController: UIAlertController = {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories below", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            print(self.tf?.text ?? "")
            self.saveCalorieIntake()
            self.tableView.reloadData()
        }))
        
        ac.addTextField { (textField) in
            self.tf = textField
        }
        return ac
    }()
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .short
       return formatter
    }()
    
    fileprivate var tf: UITextField?
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        present(alertController, animated: true)
    }
    
    func saveCalorieIntake() {
        guard let calories = tf!.text, !calories.isEmpty else {return}
        
        let cals: Int = Int(calories) ?? 0 // why does this need to be unwrapped again?
        let _ = CalorieIntake(calories: cals, dateEntered: Date())
        // Save
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return calorieIntakeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let calorieIntake = calorieIntakeArray[indexPath.row]
        cell.textLabel?.text = "Calories: \(calorieIntake.calories)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorieIntake.dateEntered ?? Date())

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

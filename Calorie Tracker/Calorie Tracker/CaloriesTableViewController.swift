//
//  CaloriesTableViewController.swift
//  Calorie Tracker
//
//  Created by Ufuk Türközü on 27.03.20.
//  Copyright © 2020 Ufuk Türközü. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    let calorieController = CalorieController()
    
    lazy var fetchResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "date",
                                             cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
     let entry = fetchResultsController.object(at: indexPath)
     // Configure the cell...
        cell.textLabel?.text = "\(entry.calories)"
        cell.detailTextLabel?.text = "\(String(describing: entry.date))"
     
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
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calories", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
        textField.placeholder = "Enter Calories:"
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let calories = alert.textFields?.first?.text, !calories.isEmpty {
                self.calorieController.create(with: Int16(calories) ?? 0, date: Date())
            }
        }))
        self.present(alert, animated: true)
    }
    
}

extension CaloriesTableViewController: NSFetchedResultsControllerDelegate {
    
}

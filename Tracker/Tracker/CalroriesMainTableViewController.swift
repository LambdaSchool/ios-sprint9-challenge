//
//  CalroriesMainTableViewController.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart
import CLTypingLabel

extension NSNotification.Name {
    static let track  = NSNotification.Name(rawValue: "Track")
}

class CalroriesMainTableViewController: UITableViewController {

    //MARK:- Properties
    
    //MARK:- Stretch
    
    @IBOutlet weak var bottomLabel: CLTypingLabel! {
        didSet {
            bottomLabel.charInterval = 0.2
            bottomLabel.continueTyping()
            bottomLabel.text = "Welcome to my amazing app!Have a great day!! :]"
            bottomLabel.font = UIFont(name: "Copperplate-Bold", size: 16)
            
            bottomLabel.textColor = #colorLiteral(red: 0.6909318566, green: 0.7678380609, blue: 0.870224297, alpha: 1)
            
        }
    }
    
    
    lazy private var dateFormatter: DateFormatter = {
        let dm = DateFormatter()
        dm.calendar = .current
        dm.dateFormat = "MMM d, yyyy 'at' HH:mm:ss a"
        return dm
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
        
    }()
    
    private let reuseCellId =  "Tracker"
    private let calorieController = CalorieController()
    
    private let calorieChart : Chart = {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let chart = Chart(frame: frame)
        
        return chart
    }()
    
    @objc private func updateChart() {
        let amountCaloriesIntake = ChartSeries(calorieController.amountArray)
         let series = amountCaloriesIntake
        calorieChart.add(series)
    }
    
    //MARK:- View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .track, object: nil)
       
    }
    
    private func setUpUI()  {
        
        tableView.tableHeaderView = calorieChart
        navigationItem.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
 
           return fetchedResultsController.sections?.count ?? 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
           return fetchedResultsController.sections?[section].numberOfObjects ?? 0
       }


       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath)
           let calorie = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = " Calories: \(calorie.amount)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.date!)
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
           return cell
       }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
           let item = fetchedResultsController.object(at: indexPath)
            calorieController.deleteItem(calorie: item)
         }
     }
    
    
    //MARK:- Action
    
    @objc private func addTapped() {
        showAlert()
    }
    
    private func showAlert() {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addTextField { (textField) in
            textField.placeholder = "Enter amount of calories"
            textField.keyboardType = .numberPad
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            guard let amount = ac.textFields![0].text, let amountToInt = Int64(amount) else {
                self.showErrorAlert()
                return
                
            }
            self.calorieController.createNewItem(amount: amountToInt)
            
            NotificationCenter.default.post(name: .track, object: self, userInfo: nil)
        }))

        present(ac, animated: true, completion: nil)
    }

    private func showErrorAlert() {
        let ac = UIAlertController(title: "Please enter a valid number", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    

}

extension CalroriesMainTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.beginUpdates()
     }
     
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.endUpdates()
     }
     
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
         switch type {
             case .insert:
                 tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
             case .delete:
                 tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
             default:
                 break
         }
     }
     
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
         switch type {
             case .insert:
                 guard let newIndexPath = newIndexPath else { return }
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
             case .update:
                 guard let indexPath = indexPath else { return }
                 tableView.reloadRows(at: [indexPath], with: .automatic)
             case .move:
                 guard let oldIndexPath = indexPath,
                     let newIndexPath = newIndexPath else { return }
                 tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
             case .delete:
                 guard let indexPath = indexPath else { return }
                 tableView.deleteRows(at: [indexPath], with: .automatic)
             @unknown default:
                 break
             
         }
     }
}

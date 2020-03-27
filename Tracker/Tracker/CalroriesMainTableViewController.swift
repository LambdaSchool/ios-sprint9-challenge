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
        let frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        let chart = Chart(frame: frame)
        chart.axesColor = .green
        chart.gridColor = .red
       
        return chart
    }()
    
    @objc private func updateChart() {
        
        var caloriesData : [(x:Double,y:Double)] = []
        
        for (index,amount) in calorieController.amountArray.enumerated() {
            caloriesData.append((Double(index),amount))
        }
        let serrie = ChartSeries(data:caloriesData)

        calorieChart.add(serrie)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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



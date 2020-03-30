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

    //MARK:- IBOutlet
    
    @IBOutlet weak var welcomeLabel: CLTypingLabel! {
        didSet {
            welcomeLabel.charInterval = 0.2
            welcomeLabel.continueTyping()
            welcomeLabel.text = "Welcome to my amazing app!Have a great day!! :]"
            
            welcomeLabel.font = UIFont(name: "Copperplate-Bold", size: 14)
            welcomeLabel.textColor = #colorLiteral(red: 0.6909318566, green: 0.7678380609, blue: 0.870224297, alpha: 1)
            
        }
    }
   //MARK:- Properties
    
    private var series : [Double] = []
    
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
        let frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        let chart = Chart(frame: frame)
        chart.axesColor = #colorLiteral(red: 0.6909318566, green: 0.7678380609, blue: 0.870224297, alpha: 1)
        chart.gridColor = .red
       
        return chart
    }()
    
    private var serie: ChartSeries  {
        let se = ChartSeries(dataForSeries)
        se.area = true
        se.color = .orange
        se.line = true
        return se
    }
    
   private var dataForSeries: [Double] {
        get {
           return fetchedResultsController.fetchedObjects!.map { (ac) -> Double in
                ac.amount }
        }
        set {
           print(newValue)
        }
    }
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        persistChart()
      
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .track, object: nil)
    }
    
    private func persistChart() {
        calorieChart.add(serie)
    }
    
    private func setUpUI()  {
        tableView.tableHeaderView = calorieChart
        navigationItem.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "NavRightBarButtonItem"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "envelope.fill"), style: .done, target: self, action: #selector(openMyTwitter))
    }
    
    @objc func openMyTwitter() {
        openTwitter()
    }
    
    @objc private func updateChart(_ notification : Notification) {
        
        print("Add new item to chart")
        
        dataForSeries.append(notification.userInfo?["Serie"] as! Double)
        calorieChart.removeAllSeries() //
        calorieChart.add(serie)
        
    }
     
    //MARK:- Table View DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
 
           return fetchedResultsController.sections?.count ?? 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
           return fetchedResultsController.sections?[section].numberOfObjects ?? 0
       }


       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath)
           let calorie = fetchedResultsController.object(at: indexPath)
        cell.accessibilityIdentifier = "Cell"
        cell.backgroundColor = #colorLiteral(red: 0.6909318566, green: 0.7678380609, blue: 0.870224297, alpha: 1)
        
        cell.textLabel?.text = " Calories: \(calorie.amount)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.textColor = .white
        
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.date!)
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        
           return cell
       }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
           let item = fetchedResultsController.object(at: indexPath)
            calorieController.deleteItem(calorie: item)
            if fetchedResultsController.fetchedObjects?.count == 0 {
                calorieChart.removeAllSeries()
            }
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
            
            guard let amount = ac.textFields![0].text, let amountAsDouble = Double(amount) else {
                self.showErrorAlert(title: "Please enter a valid number", actionTitle: "Ok")
                return
            }
           
            let userInfo : [String:Double] = ["Serie": amountAsDouble]
            
            self.calorieController.createNewItem(amount: amountAsDouble)
            
            NotificationCenter.default.post(name: .track, object: self, userInfo: userInfo)
        }))

        present(ac, animated: true, completion: nil)
    }

  
}



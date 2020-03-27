//
//  CalorieIntakeViewController.swift
//
//
//  Created by Lambda_School_Loaner_268 on 3/27/20.
//

import UIKit
import SwiftChart
import CoreData

class CalorieIntakeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties && Outlets
    
    @IBOutlet weak var calorieChart: Chart!
     
    @IBOutlet weak var CalorieTable: UITableView!
    
    let controller = CaloriesController()
    
    lazy var fetchedResultsController: NSFetchedResultsController <Calorie> = {
        let request: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let MOC = CoreDataStack.shared.mainContext
            
        request.sortDescriptors = [NSSortDescriptor(key: "timeAdded",
                            ascending: true),
            NSSortDescriptor(key: "timeAdded",
                            ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - Actions
       @IBAction func addColorieSource(_ sender: Any) {
           let alertController = UIAlertController(title: "Add Calorie Amount", message: "Enter the amount of calories in the text field! ", preferredStyle: .alert)
           
           alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Calories: "
           }
           let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { aleer -> Void in
               
            let firstTF = alertController.textFields![0] 
               
               guard let amount = firstTF.text else { return }
               self.controller.createCalorie(withCalorieAmount: amount)
               
               NotificationCenter.default.post(name: .updateChart, object: self)
               
               self.CalorieTable.reloadData()
               
           })
               
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           alertController.addAction(submitAction)
           alertController.addAction(cancelAction)
           present(alertController, animated: true, completion: nil)
           }
       
       

       
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .updateChart, object: self)
    }
    
    // MARK: - Methods
    @objc func updateChart(notification: Notification) {
        
        var data: [Double] = []
        
        for calorie in fetchedResultsController.fetchedObjects! {
            print(calorie.amount)
            data.append(Double(calorie.amount!) as! Double)
        }
        
        let series = ChartSeries(data)
        series.area = true
        calorieChart.add(series)
        self.calorieChart.subviews.forEach({ $0.removeFromSuperview() })
       
        
    }
}


extension CalorieIntakeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "Calories: \(calorie.amount ?? "0")"
        return cell
    }
    
    
}

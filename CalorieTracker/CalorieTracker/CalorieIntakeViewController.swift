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
    
    @IBOutlet weak var calorieChart: Chart!
     
    
    let controller = CaloriesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(notification:)), name: .updateChart, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: .updateChart, object: self)
    }
    
    lazy var fetchedResultsController:
        NSFetchedResultsController <Calorie> = {
        let request: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let MOC = CoreDataStack.shared.mainContext
            
        request.sortDescriptors = [NSSortDescriptor(key: "added",
                             ascending: true),
            NSSortDescriptor(key: "added",
                             ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: MOC, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
            try! frc.performFetch()
    }()
    
    
    
    @IBAction func addColorieSource(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Amount", message: "Enter the amount of calories in the text field! ", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Calories:"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let amountToSave = Int(textField.text!) else {
                    return
            }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField()
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
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
    }
    
    
}

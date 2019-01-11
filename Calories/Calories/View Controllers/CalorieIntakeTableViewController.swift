//
//  CalorieIntakeTableViewController.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import CoreData

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var intakeChart: Chart!
    
    // MARK:- View lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calorieIntakeController.fetchCalorieIntakesFromServer()
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart(_:)), name: .calorieIntakeValuesChanged, object: nil)
        
        updateChart()
    }
    
    @objc func updateChart(_ notification: Notification? = nil) {
        intakeChart.backgroundColor = .white
        intakeChart.lineWidth = 4
        intakeChart.highlightLineWidth = 6
        intakeChart.highlightLineColor = UIColor(named: "Theme")!
        
        intakeChart.series = []
        guard let dailyIntakes = fetchedResultsController.fetchedObjects else { return }
        let calories = dailyIntakes.compactMap({ $0.amount })
        let series = ChartSeries(calories)
        series.area = true
        intakeChart.add(series)
    }
    

    // MARK:- Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath) as? CalorieIntakeCell else { return UITableViewCell() }
        
        let intake = fetchedResultsController.object(at: indexPath)
        cell.calorieIntake = intake

        return cell
    }
    
    
    // NSFetchedResultsController delegate functions
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            guard let intake = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            self.calorieIntakeController.delete(calorieIntake: intake)
        }
        
        delete.backgroundColor = UIColor(named: "Background") ?? UIColor.white
        
        let fontAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold),
                        NSAttributedString.Key.foregroundColor: UIColor.red]
        let attr = NSAttributedString(string: "Delete?       ", attributes: fontAttr)
        
        UIButton.appearanceWhenContained(within: [CalorieIntakeTableViewController.self]).setAttributedTitle(attr, for: .normal)

        return [delete]
    }
    
    
    // MARK:- IBActions
    
    @IBAction func newCalorieIntakeAmount(_ sender: Any) {
        CalorieIntakePopover.shared.trigger()
    }
    
    
    // MARK:- Types & properties
    
    let calorieIntakeController = CalorieIntakeController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieIntake> = {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        
        return frc
    }()

}

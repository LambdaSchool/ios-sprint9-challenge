//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Cody Morley on 6/19/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var entriesTableView: UITableView!
    
    var entries: [Entry] = []
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    //MARK: - Actions -
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.textFields?.append(UITextField())
    }
    
    
    //MARK: - Methods -
    func updateViews() {
        chartView.series
    }
    


}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        cell.textLabel?.text = String(entries[indexPath.row].calories)
        cell.detailTextLabel?.text = entries[indexPath.row].formattedDate?.description
        return cell
    }
}


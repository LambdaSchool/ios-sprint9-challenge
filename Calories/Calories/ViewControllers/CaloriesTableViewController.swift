//
//  CaloriesTableViewController.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class CaloriesTableViewController: UITableViewController
{
    var calorieController: CalorieController?
    let cellId = "calorieCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(CalorieCell.self, forCellReuseIdentifier: cellId)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(newEntryWasAdded), name: .newEntryWasCreated, object: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return calorieController?.calories.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CalorieCell
        
        let calorie = calorieController?.calories[indexPath.row]
        
        cell.textLabel?.text = "Calories: \(calorie?.calories ?? 0)"
        cell.dateLabel.text = calorie?.date?.toString(dateFormat: "dd-MM HH:mm a")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    @objc private func newEntryWasAdded()
    {
        tableView.reloadData()
    }
    
    
}

//
//  CalorieTackerTableViewController.swift
//  CalorieTracker
//
//  Created by Clayton Watkins on 8/14/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Methods
    
    
    // MARK: - IBAction
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)

       

        return cell
    }

}

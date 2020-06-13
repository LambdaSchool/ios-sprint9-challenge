//
//  CalorieEntryTableVC.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class CalorieEntryTableVC: UITableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 0
   }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieEntryCell", for: indexPath)
    
    // Configure the cell...
    
    return cell
    }
}

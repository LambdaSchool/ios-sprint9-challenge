//
//  CalorieTableViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_34 on 3/15/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import UIKit

class CalorieTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        
        return cell
    }

}

//
//  CalorieTrackerViewController.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

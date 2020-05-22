//
//  CalorieViewController.swift
//  CalorieTracker
//
//  Created by Bradley Diroff on 5/22/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chart: Chart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
    }
    
    @IBAction func addTap(_ sender: Any) {
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

extension CalorieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CalorieTableViewCell else {return UITableViewCell()}
        
        return cell
    }
    
    
}

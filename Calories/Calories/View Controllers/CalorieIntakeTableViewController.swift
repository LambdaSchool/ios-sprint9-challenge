//
//  CalorieIntakeTableViewController.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import Popover

class CalorieIntakeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func newCalorieIntakeAmount(_ sender: Any) {
        let startPoint = CGPoint(x: self.view.frame.width - 16, y: 60)
        let aView = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 300))
        let popover = Popover(options: [.animationIn(0.275),
                                        .animationOut(0.2),
                                        .cornerRadius(14),
                                        .color(UIColor(named: "Background") ?? .clear),
                                        .blackOverlayColor(UIColor(named: "PopoverBackground") ?? .clear),
                                        .arrowSize(CGSize(width: 0.1, height: 0.1)),
                                        .initialSpringVelocity(CGFloat(0.2)),
                                        .springDamping(CGFloat(0.92))],
                              showHandler: nil,
                              dismissHandler: nil)
        popover.layer.shadowOpacity = 0.4
        popover.layer.shadowOffset = CGSize(width: 0, height: 3)
        popover.layer.shadowRadius = 7
        popover.layer.opacity = 1
        popover.show(aView, point: startPoint)
    }
    

}

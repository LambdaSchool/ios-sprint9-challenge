//
//  CalorieTrackerVC.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class CalorieTrackerVC: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      switch segue.identifier {
      case "ChartSegue":
         break
      case "TableViewSegue":
         break
      default:
         break
      }
   }
}

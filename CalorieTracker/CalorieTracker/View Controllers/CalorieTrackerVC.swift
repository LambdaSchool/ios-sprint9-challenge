//
//  CalorieTrackerVC.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerVC: UIViewController {
   
   var calorieEntryTableVC: CalorieEntryTableVC!
   
   @IBAction func addCalorieEntry(_ sender: Any) {
      CalorieEntry(calories: Int16.random(in: 1...400) * 5)
      do {
         try CoreDataStack.shared.mainContext.save()
         calorieEntryTableVC.scrollToTop()
      } catch {
         NSLog("Error saving managed object context: \(error)")
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let calorieEntryTableVC = segue.destination as? CalorieEntryTableVC {
         self.calorieEntryTableVC = calorieEntryTableVC
      }
   }
}

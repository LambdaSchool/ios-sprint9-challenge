//
//  CalorieTrackRViewController.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import UIKit

class CalorieTrackRViewController: UIViewController {
    
    //MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    @IBAction func addTapped(_ sender: Any) {
        showTextViewAlert()
    }
     
   @objc func showTextViewAlert() {
        let alertView = UIAlertController(title: "Add Calorie Intake", message: "Enter The Amount OF Calories In The Field", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: nil)
        alertView.textFields![0].placeholder = "Calories"
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
        print(alertView.textFields![0].text!)
        }))
        
        self.present(alertView, animated: true, completion: nil)
    
    }
    
    

}

extension CalorieTrackRViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                
                return cell!
    }
    
    
}

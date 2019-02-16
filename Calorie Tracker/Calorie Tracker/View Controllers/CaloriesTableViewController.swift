
import Foundation
import SwiftChart

extension NSNotification.Name {
    static let shouldShowChartDataChanged = NSNotification.Name("ShouldShowChartDataChanged")
}

class CaloriesTableViewController: UITableViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartSetUp()
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc func shouldShowChartDataChanged(_ notification: Notification) {
        
        chartSetUp()
        tableView.reloadData()
    }
    
    // MARK: - Alert Controller

    @IBAction func addButton(_ sender: Any) {
        showInputPopUp()
    }
    
    func showInputPopUp() {
        
        // Create UIAlertController, set title and message
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        
        // Confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            // Get the input values from user
            let calories = alertController.textFields?[0].text
            let caloriesInt = Int16(calories ?? "0")
            
            //guard let caloriesInt = caloriesInt else { return }
            
            // Put the user-entered amount into the caloriesInput property
            //self.calorieInputController.caloriesInput.append(CalorieInput(calories: caloriesInt!))
            
            self.calorieInputController.createInput(calories: caloriesInt!, timestamp: Date())
            
            // Put the integers only in to an array that will populate the chart
            self.calorieIntsForChart.append(Double(caloriesInt!))
            
            // Post a notification
            NotificationCenter.default.post(name: .shouldShowChartDataChanged, object: self)
        }
        
        // Cancel action does nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        // Add textfield to popup
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        // Add action to popup
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Present the popup
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: UITableViewDataSource
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        switch section {
//        case 0:
//            return 1
//        case 1: return caloriesInput.count
//        default:
//            fatalError("Illegal section")
//        }
        
        //return caloriesInput.count
        return calorieInputController.caloriesInput.count
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        let calorieInput = calorieInputController.caloriesInput[indexPath.row]
 
        cell.textLabel?.text = "Calories: \(calorieInput.calories)"
        
        if calorieInput.formattedTimeStamp != nil {
           cell.detailTextLabel?.text = "\(calorieInput.formattedTimeStamp!)"
        }
        
        return cell
        
    }
    
    // MARK: - Chart
    
    func chartSetUp() {
        
        guard let chart = chart else { return }
        
        //chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let series = ChartSeries(calorieIntsForChart)
        chart.add(series)

        series.color = ChartColors.cyanColor()
        chart.add(series)
    }
    

    
    
    // MARK: - Properties
    
    private var chart: Chart?
    
//    var caloriesInput: [CalorieInput] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    let calorieInputController = CalorieInputController()
    
    var calorieInput: CalorieInput!
    
    // test data
    var calorieIntsForChart: [Double] = [150.0, 200.0]
    

}

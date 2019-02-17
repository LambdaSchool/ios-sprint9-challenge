
import Foundation
import SwiftChart

extension NSNotification.Name {
    static let shouldShowChartDataChanged = NSNotification.Name("ShouldShowChartDataChanged")
}

class CaloriesTableViewController: UITableViewController {
    
    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.chartSetUp()
            self.tableView.reloadData()
        }
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc func shouldShowChartDataChanged(_ notification: Notification) {
        
        clearChart()
        chartView.removeAllSeries()
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

            // Put the user-entered amount into the caloriesInput property
            self.calorieInputController.createInput(calories: caloriesInt!, timestamp: Date())
            
            // Post a notification
            NotificationCenter.default.post(name: .shouldShowChartDataChanged, object: self)
            
            //self.data.append((self.data.count + 1, Double(caloriesInt!)))
            
//            self.newData.append((self.data.count + 1, Double(caloriesInt!)))
//
//            let newSeries = ChartSeries(data: self.newData)
//
//            newSeries.area = true
//            newSeries.color = ChartColors.cyanColor()
//
//            self.chartView.add(newSeries)
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
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieInput = calorieInputController.caloriesInput[indexPath.row]
            
            calorieInputController.deleteInput(calorieInput: calorieInput)
            tableView.deleteRows(at: [indexPath], with: .fade)

            clearChart()
            chartView.removeAllSeries()
            chartSetUp()
            
            NotificationCenter.default.addObserver(self, selector: #selector(shouldShowChartDataChanged(_:)), name: .shouldShowChartDataChanged, object: nil)
        }
    }
    
    // MARK: - Chart
    
    func clearChart() {
        
        data = [(0, 0.0)]
        
    }
    
    func chartSetUp() {
        
        for input in calorieInputController.caloriesInput {
            if let input = input as? CalorieInput {
                data.append((data.count, Double(input.calories)))
            }
        }
        
        let series = ChartSeries(data: data)
        series.area = true
        
        series.color = ChartColors.cyanColor()
        chartView.add(series)
        
//        let caloriesDouble = Double(calorieInput.calories)
//        let series = ChartSeries([caloriesDouble])
        //let series = ChartSeries(calorieIntsForChart)
//        let initialSeries = ChartSeries([0.0, 0.0])
//        chartView.add(initialSeries)
//
//        let series = ChartSeries([calorieInput.calories])
    

//        chartView.add([(data.count + 1, caloriesInt)])
        
    }
    
    // MARK: - Properties
    
    // Array starts at 0 in order for chart to start at 0
    private var data: [(Int, Double)] = [(0, 0.0)]
    
    let calorieInputController = CalorieInputController()
    
    var calorieInput: CalorieInput!
    
}

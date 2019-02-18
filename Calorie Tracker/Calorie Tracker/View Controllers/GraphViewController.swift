import UIKit
import SwiftChart

class GraphViewController: UIViewController {
    // MARK: - Properties
    let calorieTrackerController = CalorieTrackerController()
    @IBOutlet weak var chartView: UIView!
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    override func viewDidLoad() {
        // I couldn't use the loadChart() here, because the graph wouldn't fill up the
        // whole chartView, on initial view. I still couldn't figure out why...
        var chart: Chart = Chart()
        chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width * 1.1, height: chartView.frame.height * 1.3))
        let series = ChartSeries(calorieTrackerController.entries.map{ $0.calorie })
        series.area = true
        series.color = ChartColors.greenColor()
        chart.add(series)
        chartView.addSubview(chart)
    }
    
    func loadChart() {
        // Delete everything in the chartView.
        for view in self.chartView.subviews{
            view.removeFromSuperview()
        }
        // Rebuild the chart.
        var chart: Chart = Chart()
        chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        let series = ChartSeries(calorieTrackerController.entries.map{ $0.calorie })
        series.area = true
        series.color = ChartColors.greenColor()
        chart.add(series)
        chartView.addSubview(chart)
    }
    
    func showAlert()
    {
        let alertController = UIAlertController(title: "Add Calorie Tracker", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (UIAlertAction) in
            guard let textField = alertController.textFields?.first,
                let text = textField.text else {return}
            let calorie = Double(text) ?? 0
            self.calorieTrackerController.add(calorie: calorie)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("\nGraphViewController\nError attempting to save new entry:\n\(error)")
            }
            self.loadChart()
            NotificationCenter.default.post(name: .addCalorieEntry, object: nil)
            print("This a Notification coming from the GraphViewController.")
            print("Somebody tapped the submit button on the AlertController.")
            print("You should probably do something...")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
}

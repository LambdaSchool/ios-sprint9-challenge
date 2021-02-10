import UIKit
import CoreData
import SwiftChart
import CLTypingLabel

@available(iOS 14.0, *)
class HomeTableViewController: UITableViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK:- IBOutlet
  
  @IBOutlet weak var welcomeLabel: CLTypingLabel!

  // MARK:- Properties

  lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
    let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let context = CoreDataStack.shared.mainContext
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    try? frc.performFetch()
    return frc
    
  }()
  
  private let reuseCellId = "CalorieCell"
  private let calorieController = CalorieController()
  
  private let calorieChart: Chart = {
    let frame = CGRect(x: 0, y: 0, width: 0, height: 300)
    let chart = Chart(frame: frame)
    chart.axesColor = .link
    chart.isUserInteractionEnabled = false
    chart.gridColor = .gray
    return chart
  }()
  
  private lazy var chartSeries: ChartSeries = {

    let calories = fetchedResultsController.fetchedObjects!

    let data = calories.map( { Double($0.amount)})

    let chartSeries = ChartSeries(data)
    
    chartSeries.area = true
    chartSeries.color = .link

    chartSeries.line = true
    
    return chartSeries
  }()

  //MARK:- View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNav()
    updateViews()

    welcomeLabel.charInterval = 0.15
    welcomeLabel.continueTyping()
    welcomeLabel.text = " >>> Welcome to Track or Lack! Have a great day my friend!!! :]"
    welcomeLabel.font = UIFont(name: "Copperplate-Bold", size: 12)
    welcomeLabel.textColor = .link
    
    NotificationCenter.default.addObserver(self,selector: #selector(refreshViews(_:)), name: .shouldUpdateGraph, object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }

  private func setUpNav()  {
    tableView.tableHeaderView = calorieChart

    navigationItem.title = "Track or Lack"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(addButtonTapped))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(openMyTwitter))

    navigationItem.rightBarButtonItem?.accessibilityIdentifier = "NavRightBarButtonItem"

    let visitTwitterAction = UIAction(title: "Developer Info",
                                      image: UIImage(systemName: "person.crop.circle")) { action in
      self.openTwitter()
    }
    let createAction = UIAction(title: "Back",
                                image: UIImage(systemName: "arrow.backward")) { action in }

    let menuBarButton = UIBarButtonItem(
      title: "Add",
      image: UIImage(systemName:"person.crop.circle"),
      primaryAction: nil,
      menu: UIMenu(title: "", children: [visitTwitterAction, createAction])
    )

    self.navigationItem.leftBarButtonItem = menuBarButton
  }
  
  @objc func openMyTwitter() {
    openTwitter()
  }
  
  @objc private func refreshViews(_ notification : Notification) {
    
    if notification.name == .shouldUpdateGraph {
      updateViews()
    }
  }

  private func updateViews() {

    tableView.reloadData()

    calorieChart.removeAllSeries()

    let calories = fetchedResultsController.fetchedObjects!

    let dataSeries = calories.map { Double($0.amount) }

    calorieChart.add(ChartSeries(dataSeries))
  }
  
  //MARK:- Table View DataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return fetchedResultsController.sections?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellId, for: indexPath)

    let calorie = fetchedResultsController.object(at: indexPath)

    cell.accessibilityIdentifier = "Cell"

    cell.backgroundColor = .systemGroupedBackground

    cell.textLabel?.text = dateFormatter.string(from: calorie.date!)

    cell.textLabel?.font = UIFont(name: "Avenir Next", size: 14)

    cell.detailTextLabel?.text = "\(calorie.amount)"

    cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 20)

    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath
  ){
    if editingStyle == .delete {
      let item = fetchedResultsController.object(at: indexPath)
      
      calorieController.deleteCalorie(calorie: item)

    }
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK:- Action
  
  @objc private func addButtonTapped() {
    showTextFieldAlert()
  }
  
  private func showTextFieldAlert() {

    let alertController = UIAlertController(title: "Add Calorie Intake",
                                            message: "Enter the amount of calories in the field",
                                            preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "Cancel",
                                            style: .destructive,
                                            handler: nil))
    
    alertController.addTextField { textField in
      textField.placeholder = "e.g 462"
      textField.keyboardType = .numberPad
    }
    
    alertController.addAction(
      UIAlertAction(title: "Submit", style: .default, handler: { action in

        guard let amountString = alertController.textFields![0].text,
              let amountAsDouble = Double(amountString)
        else {
          self.showErrorAlert(title: "Please enter a valid number",
                              actionTitle: "Ok")
          return
        }
        self.calorieController.createNewItem(amount: Int(amountAsDouble))

      }))
    
    present(alertController, animated: true, completion: nil)
  }
}

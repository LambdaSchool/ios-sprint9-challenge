import CoreData

extension Calories {
    
    
    // MARK: - Initializers

    /// Creates Tasks with same Managed Object Context "moc"
    @discardableResult
    convenience init(amount: Int16,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
}

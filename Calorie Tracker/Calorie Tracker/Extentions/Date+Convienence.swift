import UIKit
import CoreData

extension Date {
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return formatter.string(from: self)
    }
}

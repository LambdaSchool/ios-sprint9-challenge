import UIKit

extension Date {
    
    func convertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        return formatter.string(from: self)
    }
}

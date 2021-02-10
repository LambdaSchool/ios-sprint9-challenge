import Foundation

public var dateFormatter: DateFormatter = {
  let dm = DateFormatter()
  dm.calendar = .current
  dm.dateFormat = "MMM d, yyyy 'at' HH:mm:ss a"
  return dm
}()

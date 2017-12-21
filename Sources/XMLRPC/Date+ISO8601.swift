import Foundation

let iso8601DateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "yyyyMMdd'T'HH:mm:ss"
    return dateFormatter
}()

extension Date {
    var iso8601String: String {
        return iso8601DateFormatter.string(from: self)
    }
}

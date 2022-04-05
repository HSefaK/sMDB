import Foundation

struct Utils {
    
    static let apiKey = "YOURAPIHERE"
    static let language = "en-US"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500/"
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    
    static func formatDate(from dateString: String) -> String? {
        let date = dateString.convertDateString()
        if let date = date {
            return date.convertToString()
        }
        return nil
    }
}

extension String {
    func convertDateString() -> Date? {
        return convert(dateString: self, fromDateFormat: "yyyy-MM-dd", toDateFormat: "dd-MM-yyyy")
    }    
    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> Date? {
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat
        if let fromDateObject = fromDateFormatter.date(from: dateString) {
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat
            return fromDateObject
        }
        return nil
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        return dateFormatter.string(from: self)
    }
}

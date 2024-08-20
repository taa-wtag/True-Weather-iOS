import Foundation
import RealmSwift

struct DateUtil {
    static func getFullDate(from dateString: String) -> String {
        let dateConvertFormatter = DateFormatter()
        dateConvertFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateConvertFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = dateConvertFormatter.date(from: dateString) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        return dateFormatter.string(from: date)
    }

    static func getWeekDay(from dateString: String) -> String {
        let dateConvertFormatter = DateFormatter()
        dateConvertFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateConvertFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateConvertFormatter.date(from: dateString) else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    static func dateComparator<T: Object> (_ first: T?, _ second: T?) -> Bool {
        let firstDate = (first as? HourlyWeatherItem)?.timeEpoch
        ?? (first as? DailyWeatherItem)?.dateEpoch
        ?? Date(timeIntervalSince1970: 0.0)
        let secondDate = (second as? HourlyWeatherItem)?.timeEpoch
        ?? (second as? DailyWeatherItem)?.dateEpoch
        ?? Date(timeIntervalSince1970: 0.0)
        return firstDate < secondDate
    }

    static func isFutureDate (_ weather: HourlyWeatherItem?) -> Bool {
        return weather?.timeEpoch?.timeIntervalSinceNow ?? -961 > -960
    }

    static func isFutureDate (_ weather: DailyWeatherItem) -> Bool {
        return weather.dateEpoch?.timeIntervalSinceNow ?? -1.0 > 0.0
    }

    static func getHoursFromTimeString(from date: String) -> Int? {
        return Int(date.dropFirst(11).dropLast(3).description)
    }
}

import Foundation

struct DailyForecastData: Decodable, Identifiable {
    var id: Int { dateEpoch ?? 0 }
    let dateString: String?
    let dateEpoch: Int?
    let dailyWeatherData: DailyWeatherData?
    let hourlyWeatherDataList: [HourlyWeatherData]?

    private enum CodingKeys: String, CodingKey {
        case dateString = "date"
        case dateEpoch = "date_epoch"
        case dailyWeatherData = "day"
        case hourlyWeatherDataList = "hour"
    }
}

import Foundation

struct ForecastData: Decodable{
    let dailyForecastDataList: [DailyForecastData]?
    
    private enum CodingKeys : String, CodingKey {
        case dailyForecastDataList = "forecastday"
    }
}

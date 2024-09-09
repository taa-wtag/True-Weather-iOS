import Foundation

struct WeatherResponse: Decodable {
    let currentWeatherData: HourlyWeatherData?

    let forecastData: ForecastData?
    
    private enum CodingKeys : String, CodingKey {
        case currentWeatherData = "current"
        case forecastData = "forecast"
    }
}

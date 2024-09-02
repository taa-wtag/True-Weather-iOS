import Foundation
@testable import True_Weather

class MockWeatherService: WeatherServiceProtocol {
    var hasError = false
    var hasCachedWeather = true
    var addWeatherCount = 0
    var hourlyWeatherList: [HourlyWeatherItem] = []
    var dailyWeatherList: [DailyWeatherItem] = []
    var currentWeatherData: HourlyWeatherData?
    var newCurrentWeather: HourlyWeatherItem?
    var forecastWeatherData: ForecastData?
    var errorMessage = ""

    func getCurrentWeatherFromRemote(in city: String, completion: @escaping (String?, HourlyWeatherData?) -> Void) {
        if !hasError {
            hasCachedWeather = true
            completion(nil, currentWeatherData)
            hasCachedWeather = false
        } else {
            completion(errorMessage, nil)
        }
    }

    func getForecastWeatherFromRemote(
        in city: String, days: Int?,
        completion: @escaping (String?, HourlyWeatherData?, ForecastData?) -> Void
    ) {
        if !hasError {
            hasCachedWeather = true
            completion(nil, currentWeatherData, forecastWeatherData)
            hasCachedWeather = false
        } else {
            completion(errorMessage, nil, nil)
        }
    }

    func getWeatherFromCache(in city: String, completion: @escaping ([HourlyWeatherItem], [DailyWeatherItem]) -> Void) {
        if hasCachedWeather {
            completion(hourlyWeatherList, dailyWeatherList)
        } else {
            completion([], [])
        }
    }

    func addWeather<T>(to city: String, weather: T) {
        addWeatherCount+=1
        if let weather = newCurrentWeather {
            hourlyWeatherList = [weather]
        }
    }
}

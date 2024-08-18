import Foundation
import RealmSwift

protocol WeatherServiceProtocol {
    func getCurrentWeatherFromRemote(
        in city: String,
        completion: @escaping(String?, HourlyWeatherData?) -> Void
    )

    func getForecastWeatherFromRemote(
        in city: String,
        days: Int?,
        completion: @escaping(String?, HourlyWeatherData?, ForecastData?) -> Void
    )

    func getWeatherFromCache(
        in city: String,
        completion: @escaping (List<HourlyWeatherItem>, List<DailyWeatherItem>) -> Void
    )

    func  addWeather <T>(to city: String, weather: T)
}

class WeatherService: WeatherServiceProtocol {
    static let shared = WeatherService()
    private let networkRequestService = NetworkRequestService.sharedInstance
    private let database = DatabaseManager.sharedInstance

    private init() {}

    private func getCity(city: String) -> CityItem? {
        database.get(CityItem.self) { $0.cityName == city }
    }

    func getCurrentWeatherFromRemote(
        in city: String,
        completion: @escaping (String?, HourlyWeatherData?) -> Void
    ) {
        let query = WeatherQuery(placeName: city)
        let request = WeatherAPIRouter.getCurrentWeather(from: query)
        networkRequestService.request(request, responseType: WeatherResponse.self) { error, data in
            if error == nil, let currentWeather = data?.currentWeatherData {
                completion(error, currentWeather)
            } else {
                completion(error, nil)
            }
        }
    }

    func getForecastWeatherFromRemote(
        in city: String,
        days: Int? = nil,
        completion: @escaping (String?, HourlyWeatherData?, ForecastData?) -> Void
    ) {
        let query = WeatherQuery(placeName: city, forecastDays: days)
        let request = WeatherAPIRouter.getForecastWeather(from: query)
        networkRequestService.request(request, responseType: WeatherResponse.self) { error, data in
            if error == nil, let weatherData = data {
                completion(error, weatherData.currentWeatherData, weatherData.forecastData)
            } else {
                completion(error, nil, nil)
            }
        }
    }

    func getWeatherFromCache(
        in city: String,
        completion: @escaping (List<HourlyWeatherItem>, List<DailyWeatherItem>) -> Void
    ) {
        if let item = getCity(city: city) {
            let oldWeatherItems = WeatherUtil.getOldWeatherItems(from: item)
//            database.delete(oldWeatherItems.0)
//            database.delete(oldWeatherItems.1)
            completion(item.weatherEveryHour, item.weatherEveryDay)
        } else {
            completion(List<HourlyWeatherItem>(), List<DailyWeatherItem>())
        }
    }

    func addWeather<T>(to city: String, weather: T) {
        if let city = getCity(city: city) {
            switch weather {
            case is HourlyWeatherItem:
                if let item = weather as? HourlyWeatherItem {
                    database.delete(WeatherUtil.duplicateWeatherItems(in: city, weather: item))
                    let cityItem = CityItem(value: city)
                    cityItem.weatherEveryHour.append(item)
                    database.update(cityItem)
                }
            case is DailyWeatherItem:
                if let item = weather as? DailyWeatherItem {
                    database.delete(WeatherUtil.duplicateWeatherItems(in: city, weather: item))
                    let cityItem = CityItem(value: city)
                    cityItem.weatherEveryDay.append(item)
                    database.update(cityItem)
                }
            case is [HourlyWeatherItem]:
                if let item = weather as? [HourlyWeatherItem] {
                    database.deleteAll(WeatherUtil.duplicateWeatherItems(in: city, weather: item))
                    let cityItem = CityItem(value: city)
                    cityItem.weatherEveryHour.append(objectsIn: item)
                    database.update(cityItem)
                }
            case is [DailyWeatherItem]:
                if let item = weather as? [DailyWeatherItem] {
                    database.deleteAll(WeatherUtil.duplicateWeatherItems(in: city, weather: item))
                    let cityItem = CityItem(value: city)
                    cityItem.weatherEveryDay.append(objectsIn: item)
                    database.update(cityItem)
                }
            default:
                return
            }
        }
    }
}

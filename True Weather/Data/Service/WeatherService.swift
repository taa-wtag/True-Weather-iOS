import Foundation

protocol WeatherServiceProtocol {
    func getCurrentWeatherFromRemote(
        in city: String,
        completion: @escaping(String?, HourlyWeatherData?) -> Void
    )

    func getForecastWeatherFromRemote(
        in city: String,
        days: Int?,
        completion: @escaping(String?, [HourlyWeatherData]?, [DailyWeatherData]?) -> Void
    )

    func getCurrentWeatherFromCache(
        in city: String,
        completion: @escaping(HourlyWeatherItem?) -> Void
    )

    func getWeatherForecastInDaysFromCache(
        in city: String,
        days: Int?,
        completion: @escaping([DailyWeatherItem]?) -> Void
    )

    func getWeatherForecastInHoursFromCache(
        in city: String,
        days: Int?,
        completion: @escaping([HourlyWeatherItem]?) -> Void
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
        completion: @escaping (String?, [HourlyWeatherData]?, [DailyWeatherData]?) -> Void
    ) {
        let query = WeatherQuery(placeName: city, forecastDays: days)
        let request = WeatherAPIRouter.getCurrentWeather(from: query)
        networkRequestService.request(request, responseType: WeatherResponse.self) { error, data in
            if error == nil, let weatherData = data {
                let hourlyWeatherList = weatherData
                    .forecastData?
                    .dailyForecastDataList?
                    .compactMap { $0.hourlyWeatherDataList }
                    .flatMap { $0 }
                let dailyWeatherList = weatherData.forecastData?.dailyForecastDataList?.compactMap {
                    $0.dailyWeatherData
                }
                completion(error, hourlyWeatherList, dailyWeatherList)
            } else {
                completion(error, nil, nil)
            }
        }
    }

    func getCurrentWeatherFromCache(
        in city: String,
        completion: @escaping (HourlyWeatherItem?) -> Void
    ) {
        let cityItem = getCity(city: city)
        if let item = cityItem {
            let currentWeather = item.weatherEveryHour
                .sorted {
                    $0.timeEpoch ?? Date(timeIntervalSince1970: 0.0) <
                        $1.timeEpoch ?? Date(timeIntervalSince1970: 0.0)
                }
                .first { $0.timeEpoch?.timeIntervalSinceNow ?? -1.0 >= 0.0 }
            completion(currentWeather)
        } else {
            completion(nil)
        }
    }

    func getWeatherForecastInDaysFromCache(
        in city: String, days: Int? = nil,
        completion: @escaping ([DailyWeatherItem]?) -> Void
    ) {
        let cityItem = getCity(city: city)
        if let item = cityItem {
            let dailyWeatherItems = item.weatherEveryDay
                .sorted {
                    $0.dateEpoch ?? Date(timeIntervalSince1970: 0.0) <
                        $1.dateEpoch ?? Date(timeIntervalSince1970: 0.0)
                }
                .filter { $0.dateEpoch?.timeIntervalSinceNow ?? -1.0 >= 0.0 }
            completion(dailyWeatherItems)
        } else {
            completion(nil)
        }
    }

    func getWeatherForecastInHoursFromCache(
        in city: String, days: Int? = nil,
        completion: @escaping ([HourlyWeatherItem]?) -> Void
    ) {
        let cityItem = getCity(city: city)
        if let item = cityItem {
            let hourlyWeatherItems = item.weatherEveryHour
                .sorted {
                    $0.timeEpoch ?? Date(timeIntervalSince1970: 0.0) <
                        $1.timeEpoch ?? Date(timeIntervalSince1970: 0.0)
                }
                .filter { $0.timeEpoch?.timeIntervalSinceNow ?? -1.0 >= 0.0 }
            completion(hourlyWeatherItems)
        } else {
            completion(nil)
        }
    }

    func addWeather<T>(to city: String, weather: T) {
        let cityItem = getCity(city: city)
        switch weather {
        case is HourlyWeatherItem:
            if let item = weather as? HourlyWeatherItem {
                cityItem?.weatherEveryHour.append(item)
                database.save(cityItem)
            }
        case is DailyWeatherItem:
            if let item = weather as? DailyWeatherItem {
                cityItem?.weatherEveryDay.append(item)
                database.save(cityItem)
            }
        case is [HourlyWeatherItem]:
            if let item = weather as? [HourlyWeatherItem] {
                cityItem?.weatherEveryHour.append(objectsIn: item)
                database.save(cityItem)
            }
        case is [DailyWeatherItem]:
            if let item = weather as? [DailyWeatherItem] {
                cityItem?.weatherEveryDay.append(objectsIn: item)
                database.save(cityItem)
            }
        default:
            return
        }
    }
}

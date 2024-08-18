import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func didUpdateCurrentWeather()
    func didUpdateForecastWeather()
    func didFinishLoadingCities()
    func didUpdateCurrentCity()
}

class WeatherViewModel {
    private let cityService: CityServiceProtocol
    private let weatherService: WeatherServiceProtocol

    private var isFirstTimeLoad = true

    var cityList: [CityItem] = [] {
        didSet {
            delegate?.didFinishLoadingCities()
            if isFirstTimeLoad {
                currentCity = cityList.first
                isFirstTimeLoad = false
            }
        }
    }

    var currentCity: CityItem? {
        didSet {
            setCurrentCity()
            delegate?.didUpdateCurrentCity()
        }
    }

    var currentWeather: HourlyWeatherItem? {
        didSet {
            delegate?.didUpdateCurrentWeather()
        }
    }

    var dailyWeatherList: [DailyWeatherItem] = [] {
        didSet {
            delegate?.didUpdateForecastWeather()
        }
    }

    var hourlyWeatherList: [HourlyWeatherItem] = []

    weak var delegate: WeatherViewModelDelegate?

    init(
        cityService: CityService = CityService.shared,
        weatherService: WeatherService = WeatherService.shared,
        delegate: WeatherViewModelDelegate? = nil
    ) {
        self.cityService = cityService
        self.weatherService = weatherService
        self.delegate = delegate
    }

    func getAllCities() {
        cityService.getAllCities { [weak self] cities in
            self?.cityList = cities
        }
    }

    private func setCurrentCity() {
        loadForecastWeatherData()
    }

    func loadCurrentWeatherData() {
        loadCurrentWeatherFromCache { [weak self] data in
            if data?.timeEpoch?.timeIntervalSinceNow ?? 961 > 960 {
                self?.fetchCurrentWeatherFromRemote { [weak self] _ in
                    self?.loadCurrentWeatherData()
                }
            } else if let currentWeather = data {
                self?.currentWeather = currentWeather
            }
        }
    }

    private func fetchCurrentWeatherFromRemote(completion: @escaping ((HourlyWeatherItem) -> Void)) {
        if let city = currentCity?.cityName {
            weatherService.getCurrentWeatherFromRemote(in: city) { [weak self] _, data in
                if let weather = data {
                    let currentWeather = WeatherUtil.getHourlyWeatherItem(from: weather)
                    self?.weatherService.addWeather(to: city, weather: currentWeather)
                    completion(currentWeather)
                }
            }
        }
    }

    private func loadCurrentWeatherFromCache(completion: @escaping (HourlyWeatherItem?) -> Void) {
        if let city = currentCity?.cityName {
            weatherService.getWeatherFromCache(in: city) { data, _ in
                completion(WeatherUtil.getCurrentWeather(from: data))
            }
        }
    }

    func loadForecastWeatherData() {
        loadForecastWeatherFromCache { [weak self] hourlyData, dailyData in
            if let dailyWeatherList = dailyData,
               let hourlyWeatherList = hourlyData,
               dailyWeatherList.count >= Constants.Weather.ForecastMaxDays - 1 {
                self?.dailyWeatherList = dailyWeatherList.sorted {
                    $0.dateEpoch ?? Date(timeIntervalSince1970: 0) < $1.dateEpoch ?? Date(timeIntervalSince1970: 0)
                }
                self?.hourlyWeatherList =  hourlyWeatherList.sorted {
                    $0.timeEpoch ?? Date(timeIntervalSince1970: 0) < $1.timeEpoch ?? Date(timeIntervalSince1970: 0)
                } .filter {
                    if let time = $0.timeEpoch?.timeIntervalSinceNow {
                        return time > 0 && time < 86400
                    } else {
                        return false
                    }
                }
                self?.delegate?.didUpdateForecastWeather()
            } else {
                self?.fetchForecastWeatherFromRemote { _, _  in
                    self?.loadForecastWeatherData()
                }
            }
        }
    }

    private func fetchForecastWeatherFromRemote(
        completion: @escaping ([HourlyWeatherItem], [DailyWeatherItem]) -> Void
    ) {
        if let city = currentCity?.cityName {
            weatherService.getForecastWeatherFromRemote(
                in: city, days: Constants.Weather.ForecastMaxDays
            ) { [weak self] _, currentData, forecastData in
                if let forecastWeather = forecastData?.dailyForecastDataList, let currentWeather = currentData {
                    self?.weatherService.addWeather(
                        to: city,
                        weather: WeatherUtil.getHourlyWeatherItem(from: currentWeather)
                    )
                    let dailyWeatherList = forecastWeather.map { data in
                        WeatherUtil.getDailyWeatherItem(
                            from: data.dailyWeatherData,
                            dateString: data.dateString,
                            dateEpoch: data.dateEpoch
                        )
                    }
                    let hourlyWeatherList = forecastWeather
                        .map { $0.hourlyWeatherDataList?.map { WeatherUtil.getHourlyWeatherItem(from: $0) } ?? [] }
                        .flatMap { $0 }
                    self?.weatherService.addWeather(to: city, weather: hourlyWeatherList)
                    self?.weatherService.addWeather(to: city, weather: dailyWeatherList)
                    completion(hourlyWeatherList, dailyWeatherList)
                }
            }
        }
    }

    private func loadForecastWeatherFromCache(
        completion: @escaping ([HourlyWeatherItem]?, [DailyWeatherItem]?) -> Void
    ) {
        if let city = currentCity?.cityName {
            weatherService.getWeatherFromCache(in: city) { hourlyData, dailyData in
                let hourlyWeatherList = hourlyData
                    .sorted { DateUtil.dateComparator($0, $1) }
                    .filter { DateUtil.isFutureDate($0) && $0.timeEpoch?.timeIntervalSinceNow ?? -1.0 < 86400 }
                let dailyWeatherList = dailyData
                    .sorted { DateUtil.dateComparator($0, $1) }
                    .filter { DateUtil.isFutureDate($0) }
                completion(hourlyWeatherList, dailyWeatherList)
            }
        }
    }
}

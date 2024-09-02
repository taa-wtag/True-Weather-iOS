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
    private let locationService: LocationServiceProtocol

    private(set) var errorMessage = ""

    private(set) var cityList: [CityItem] = [] {
        didSet {
            delegate?.didFinishLoadingCities()
        }
    }

    private(set) var currentCity: CityItem? {
        didSet {
            delegate?.didUpdateCurrentCity()
        }
    }

    private(set) var currentWeather: HourlyWeatherItem? {
        didSet {
            delegate?.didUpdateCurrentWeather()
        }
    }

    private(set) var dailyWeatherList: [DailyWeatherItem] = [] {
        didSet {
            delegate?.didUpdateForecastWeather()
        }
    }

    private(set) var hourlyWeatherList: [HourlyWeatherItem] = []

    weak var delegate: WeatherViewModelDelegate?

    init(
        cityService: CityServiceProtocol,
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        delegate: WeatherViewModelDelegate? = nil
    ) {
        self.cityService = cityService
        self.weatherService = weatherService
        self.locationService = locationService
        self.delegate = delegate
        (locationService as? LocationService)?.delegate = self
    }

    func getAllCities() {
        cityService.getAllCities { [weak self] cities in
            self?.cityList = cities
        }
    }

    func setCurrentCity(index: Int) {
        if index < cityList.count && index >= 0 {
            loadCurrentWeatherData(in: cityList[index])
            loadForecastWeatherData(in: cityList[index])
            currentCity = cityList[index]
        } else {
            hourlyWeatherList = []
            dailyWeatherList = []
            currentCity = nil
        }
    }

    func loadCurrentWeatherData(in city: CityItem? = nil) {
        loadCurrentWeatherFromCache(in: city) { [weak self] data in
            if data?.timeEpoch?.timeIntervalSinceNow ?? 500 > 300 {
                self?.fetchCurrentWeatherFromRemote(in: city) { [weak self] _ in
                    self?.loadCurrentWeatherData(in: city)
                }
            } else if let currentWeather = data {
                self?.currentWeather = currentWeather
            }
        }
    }

    private func fetchCurrentWeatherFromRemote(
        in city: CityItem? = nil,
        completion: @escaping (HourlyWeatherItem) -> Void
    ) {
        if let city = city?.cityName ?? currentCity?.cityName {
            weatherService.getCurrentWeatherFromRemote(in: city) { [weak self] errorMessage, data in
                if let weather = data {
                    let currentWeather = WeatherUtil.getHourlyWeatherItem(from: weather)
                    self?.weatherService.addWeather(to: city, weather: currentWeather)
                    completion(currentWeather)
                } else if let error = errorMessage {
                    self?.errorMessage = error
                }
            }
        }
    }

    private func loadCurrentWeatherFromCache(
        in city: CityItem? = nil,
        completion: @escaping (HourlyWeatherItem?) -> Void
    ) {
        if let city = city?.cityName ?? currentCity?.cityName {
            weatherService.getWeatherFromCache(in: city) { data, _ in
                completion(WeatherUtil.getCurrentWeather(from: data))
            }
        }
    }

    func loadForecastWeatherData(in city: CityItem? = nil) {
        loadForecastWeatherFromCache(in: city) { [weak self] hourlyData, dailyData in
            if let dailyWeatherList = dailyData,
               let hourlyWeatherList = hourlyData,
               dailyWeatherList.count >= Constants.Weather.ForecastMaxDays - 1 {
                self?.dailyWeatherList = dailyWeatherList.sorted { DateUtil.dateComparator($0, $1) }
                let hourlyWeatherList =  hourlyWeatherList.sorted { DateUtil.dateComparator($0, $1) }
                let firstTime = DateUtil.getHoursFromTimeString(from: hourlyWeatherList.first?.timeString) ?? 0
                self?.hourlyWeatherList = hourlyWeatherList.filter {
                    if let time = $0.timeEpoch?.timeIntervalSinceNow {
                        let hourInt = DateUtil.getHoursFromTimeString(from: $0.timeString) ?? -1
                        return time > 0 && time <= 82800 && (hourInt >= firstTime || hourInt == 0)
                    } else {
                        return false
                    }
                }
                self?.delegate?.didUpdateForecastWeather()
            } else {
                self?.fetchForecastWeatherFromRemote(in: city) { _, _  in
                    self?.loadForecastWeatherData(in: city)
                }
            }
        }
    }

    private func fetchForecastWeatherFromRemote(
        in city: CityItem? = nil,
        completion: @escaping ([HourlyWeatherItem], [DailyWeatherItem]) -> Void
    ) {
        if let city = city?.cityName ?? currentCity?.cityName {
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
                        .compactMap { $0.hourlyWeatherDataList?.map { WeatherUtil.getHourlyWeatherItem(from: $0) } }
                        .flatMap { $0 }
                    self?.weatherService.addWeather(to: city, weather: hourlyWeatherList)
                    self?.weatherService.addWeather(to: city, weather: dailyWeatherList)
                    completion(hourlyWeatherList, dailyWeatherList)
                }
            }
        }
    }

    private func loadForecastWeatherFromCache(
        in city: CityItem? = nil,
        completion: @escaping ([HourlyWeatherItem]?, [DailyWeatherItem]?) -> Void
    ) {
        if let city = city?.cityName ?? currentCity?.cityName {
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

    func getCurrentLocation() {
        if locationService.isAuthorized() {
            locationService.requestLocationOnce()
        } else {
            locationService.requestAuthorization()
        }
    }
}

extension WeatherViewModel: LocationServiceDelegate {
    func didFetchLocation(latitude: Double, longitude: Double) {
        cityService.getCityNameFromLocation(
            from: (latitude: latitude, longitude: longitude)
        ) { [weak self] errorMessage, data in
            if let cityName = data?.first?.cityName, let countryName = data?.first?.countryName {
                let cityString = "\(cityName), \(countryName)"
                self?.cityService.getCity(name: cityString) { cityItem in
                    if cityItem == nil {
                        let city = CityItem()
                        city.cityName = cityString
                        city.backgroundColor = Int.random(in: 0..<6)
                        self?.cityService.addCity(city: city)
                        self?.getAllCities()
                    }
                }
            } else if let error = errorMessage {
                self?.errorMessage = error
            }
        }
    }
}

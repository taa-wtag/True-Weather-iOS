import Foundation

protocol CityViewModelDelegate: AnyObject {
    func didFinishLoadingCities()
}

class CityViewModel {
    private let cityService: CityServiceProtocol
    private let weatherService: WeatherServiceProtocol

    var isDeleteButtonHidden = true

    private (set) var errorMessage = ""

    private(set) var cityList: [CityItem] = [] {
        didSet {
            delegate?.didFinishLoadingCities()
        }
    }

    private(set) var currentWeatherList: [String: HourlyWeatherItem] = [:] {
        didSet {
            delegate?.didFinishLoadingCities()
        }
    }

    weak var delegate: CityViewModelDelegate?

    init(
        cityService: CityServiceProtocol = CityService.shared,
        weatherService: WeatherServiceProtocol = WeatherService.shared,
        delegate: CityViewModelDelegate? = nil
    ) {
        self.cityService = cityService
        self.weatherService = weatherService
        self.delegate = delegate
        getAllCities()
    }

    func getAllCities() {
        cityService.getAllCities { [weak self] cities in
            self?.cityList = cities
            cities.forEach {
                if let cityName = $0.cityName {
                    self?.currentWeatherList.updateValue(HourlyWeatherItem(), forKey: cityName)
                    self?.loadCurrentWeatherData(city: $0)
                }
            }
        }
    }

    func deleteCity(at index: Int) {
        if let cityName = cityList[index].cityName {
            cityService.deleteCity(city: cityName) { [weak self] in
                self?.currentWeatherList.removeValue(forKey: cityName)
                self?.getAllCities()
            }
        }
    }

    private func loadCurrentWeatherData(city: CityItem) {
        loadCurrentWeatherFromCache(city: city) { [weak self] data in
            if data?.timeEpoch?.timeIntervalSinceNow ?? 500 > 300 {
                self?.fetchCurrentWeatherFromRemote(city: city) { [weak self] _ in
                    self?.loadCurrentWeatherData(city: city)
                }
            } else if let weather = data, let cityName = city.cityName {
                self?.currentWeatherList.updateValue(weather, forKey: cityName)
            }
        }
    }

    private func fetchCurrentWeatherFromRemote(city: CityItem, completion: @escaping ((HourlyWeatherItem) -> Void)) {
        if let cityName = city.cityName {
            weatherService.getCurrentWeatherFromRemote(in: cityName) { [weak self] error, data in
                if let weather = data {
                    let currentWeather = WeatherUtil.getHourlyWeatherItem(from: weather)
                    self?.weatherService.addWeather(to: cityName, weather: currentWeather)
                    completion(currentWeather)
                } else if let error = error {
                    self?.errorMessage = error
                }
            }
        }
    }

    private func loadCurrentWeatherFromCache(city: CityItem, completion: @escaping (HourlyWeatherItem?) -> Void) {
        if let cityName = city.cityName {
            weatherService.getWeatherFromCache(in: cityName) { data, _ in
                completion(WeatherUtil.getCurrentWeather(from: data))
            }
        }
    }
}

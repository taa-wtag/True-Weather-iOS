import Foundation

protocol CityViewModelDelegate: AnyObject {
    func didFinishLoadingCities()
}

class CityViewModel {
    private let cityService: CityServiceProtocol
    private let weatherService: WeatherServiceProtocol

    var isDeleteButtonHidden = true

    var cityList: [CityItem] = [] {
        didSet {
            delegate?.didFinishLoadingCities()
        }
    }

    var currentWeatherList: [String: HourlyWeatherItem] = [:] {
        didSet {
            delegate?.didFinishLoadingCities()
        }
    }

    weak var delegate: CityViewModelDelegate?

    init(
        cityService: CityService = CityService.shared,
        weatherService: WeatherService = WeatherService.shared,
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
                self?.currentWeatherList.updateValue(HourlyWeatherItem(), forKey: $0.cityName ?? "")
                self?.loadCurrentWeatherData(city: $0)
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
            if !DateUtil.isFutureDate(data) {
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
            weatherService.getCurrentWeatherFromRemote(in: cityName) { [weak self] _, data in
                if let weather = data {
                    let currentWeather = WeatherUtil.getHourlyWeatherItem(from: weather)
                    self?.weatherService.addWeather(to: cityName, weather: currentWeather)
                    completion(currentWeather)
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

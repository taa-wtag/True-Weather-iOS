@testable import True_Weather

class MockWeatherViewModelDelegate: WeatherViewModelDelegate {
    var didUpdateCurrentWeatherCalled = false
    var didUpdateForecastWeatherCalled = false
    var didFinishLoadingCitiesCalled = false
    var didUpdateCurrentCityCalled = false

    func didUpdateCurrentWeather() {
        didUpdateCurrentWeatherCalled = true
    }

    func didUpdateForecastWeather() {
        didUpdateForecastWeatherCalled = true
    }

    func didFinishLoadingCities() {
        didFinishLoadingCitiesCalled = true
    }

    func didUpdateCurrentCity() {
        didUpdateCurrentCityCalled = true
    }
}

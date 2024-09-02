import Foundation
@testable import True_Weather

class MockCityViewModelDataHelper {
    func cityList() -> [CityItem] {
        var cityList: [CityItem] = []
        let dhaka = CityItem()
        dhaka.cityName = "Dhaka, Bangladesh"
        cityList.append(dhaka)
        let tokyo = CityItem()
        tokyo.cityName = "Tokyo, Japan"
        cityList.append(tokyo)
        return cityList
    }

    func city() -> CityItem {
        let dhaka = CityItem()
        dhaka.cityName = "Dhaka, Bangladesh"
        return dhaka
    }

    func futureCurrentWeather() -> HourlyWeatherItem {
        let weather = HourlyWeatherItem()
        weather.timeString = "2020-01-01 03:00"
        weather.timeEpoch = Date(timeIntervalSinceNow: 800)
        return weather
    }

    func expiredCurrentWeather() -> HourlyWeatherItem {
        let weather = HourlyWeatherItem()
        weather.timeString = "2020-01-01 01:00"
        weather.timeEpoch = Date(timeIntervalSinceNow: -1000)
        return weather
    }

    func currentWeather() -> HourlyWeatherItem {
        let weather = HourlyWeatherItem()
        weather.timeString = "2020-01-01 02:00"
        weather.timeEpoch = Date(timeIntervalSinceNow: 100)
        return weather
    }

    func currentWeatherData() -> HourlyWeatherData {
        let weather = HourlyWeatherData(
            timeString: "2020-01-01 01:00",
            timeEpoch: Int(Date(timeIntervalSinceNow: 800).timeIntervalSince1970)
        )
        return weather
    }
}

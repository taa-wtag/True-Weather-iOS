import Foundation
@testable import True_Weather

class MockWeatherViewModelDataHelper {
    func cityDataList() -> [CityData] { [
            CityData(cityName: "Dhaka", countryName: "Bangladesh"),
            CityData(cityName: "Tokyo", countryName: "Japan")
        ]
    }

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

    func cityItem() -> CityItem {CityItem()}

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

    func forecastWeatherData() -> ForecastData {
        let dailyForecastData = DailyForecastData(
            dateString: "2020-01-01",
            dateEpoch: Int(Date(timeIntervalSinceNow: 800).timeIntervalSince1970),
            dailyWeatherData: DailyWeatherData(),
            hourlyWeatherDataList: [currentWeatherData()]
        )
        return ForecastData(dailyForecastDataList: [dailyForecastData])
    }

    func dailyWeatherList() -> [DailyWeatherItem] {
        var weatherList: [DailyWeatherItem] = []
        for count in 1 ..< 10 {
            let weather = DailyWeatherItem()
            weather.dateString = "2020-01-0\(count)"
            weather.dateEpoch = Date(timeIntervalSinceNow: Double(-8600 + count * 86400))
            weatherList.append(weather)
        }
        weatherList.reverse()
        weatherList.append(DailyWeatherItem())
        return weatherList
    }

    func hourlyWeatherList() -> [HourlyWeatherItem] {
        var weatherList: [HourlyWeatherItem] = []
        for count in 0 ..< 28 {
            let weather = HourlyWeatherItem()
            let countString = String(count%24)
            let hour = String(repeating: "0", count: 2 - countString.count).appending(countString)
            weather.timeString = "2020-01-0\(count<25 ? 1 : 2) \(hour):00"
            weather.timeEpoch = Date(timeIntervalSinceNow: Double(-1000 + count * 3600))
            weatherList.append(weather)
        }
        weatherList.reverse()
        weatherList.append(currentWeather())
        weatherList.append(HourlyWeatherItem())
        return weatherList
    }

}

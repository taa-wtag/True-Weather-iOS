import Foundation
import RealmSwift

struct WeatherUtil {
    static func getCurrentWeather(from data: List<HourlyWeatherItem>) -> HourlyWeatherItem? {
        return data
            .sorted { DateUtil.dateComparator($0, $1) }
            .first { DateUtil.isFutureDate($0) }
    }

    static func duplicateWeatherItems(in city: CityItem, weather: HourlyWeatherItem) -> HourlyWeatherItem? {
        city.weatherEveryHour.first { data in
            weather.timeString == data.timeString
        }
    }

    static func duplicateWeatherItems(in city: CityItem, weather: [HourlyWeatherItem]) -> [HourlyWeatherItem] {
        var weatherList: [HourlyWeatherItem] = []
        weather.forEach { data in
            if let item = city.weatherEveryHour.first(where: {$0.timeString == data.timeString}) {
                weatherList.append(item)
            }
        }
        return weatherList
    }

    static func duplicateWeatherItems(in city: CityItem, weather: DailyWeatherItem) -> DailyWeatherItem? {
        city.weatherEveryDay.first { data in
            weather.dateString == data.dateString
        }
    }

    static func duplicateWeatherItems(in city: CityItem, weather: [DailyWeatherItem]) -> [DailyWeatherItem] {
        var weatherList: [DailyWeatherItem] = []
        weather.forEach { data in
            if let item = city.weatherEveryDay.first(where: {$0.dateString == data.dateString}) {
                weatherList.append(item)
            }
        }
        return weatherList
    }

    static func getOldWeatherItems(from city: CityItem) -> (
        LazyFilterSequence<List<HourlyWeatherItem>>,
        LazyFilterSequence<List<DailyWeatherItem>>
    ) {
        let hourlyWeatherItems = city
            .weatherEveryHour
            .filter { !DateUtil.isFutureDate($0) }
        let dailyWeatherItems = city
            .weatherEveryDay
            .filter { !DateUtil.isFutureDate($0) }
        return (hourlyWeatherItems, dailyWeatherItems)
    }

    static func getHourlyWeatherItem(from data: HourlyWeatherData?) -> HourlyWeatherItem {
        let weather = HourlyWeatherItem()
        if let timeNow = data?.timeEpoch {
            weather.timeEpoch = Date(timeIntervalSince1970: Double(timeNow))
        }
        weather.timeString = data?.timeString
        weather.tempC = data?.tempC
        weather.tempF = data?.tempF
        weather.feelsLikeC = data?.feelsLikeC
        weather.feelsLikeF = data?.feelsLikeF
        weather.visKm = data?.visKm
        weather.visMiles = data?.visMiles
        weather.windKph = data?.windKph
        weather.windMph = data?.windMph
        weather.humidity = data?.humidity
        weather.isDay = data?.isDay
        weather.conditionText = data?.weatherCondition?.text
        return weather
    }

    static func getDailyWeatherItem(
        from data: DailyWeatherData?,
        dateString: String? = nil,
        dateEpoch: Int? = nil
    ) -> DailyWeatherItem {
        let weather = DailyWeatherItem()
        if let date = dateEpoch {
            weather.dateEpoch = Date(timeIntervalSince1970: Double(date))
        }
        weather.dateString = dateString
        weather.minTempC = data?.minTempC
        weather.minTempF = data?.minTempF
        weather.maxTempC = data?.maxTempC
        weather.maxTempF = data?.maxTempF
        weather.avgTempC = data?.avgTempC
        weather.avgTempF = data?.avgTempF
        weather.avgVisKm = data?.avgVisKm
        weather.avgVisMiles = data?.avgVisMiles
        weather.maxWindKph = data?.maxWindKph
        weather.maxWindMph = data?.maxWindMph
        weather.avgHumidity = data?.avgHumidity
        weather.conditionText = data?.weatherCondition?.text
        return weather
    }
}

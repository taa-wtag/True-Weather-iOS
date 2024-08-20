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
        weather.imageUrl = data?.weatherCondition?.icon?.dropFirst(21).description
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
        weather.imageUrl = data?.weatherCondition?.icon?.dropFirst(21).description
        return weather
    }

    static func getShortCondition(from text: String) -> String {
        let correctedText = text.lowercased()
        if correctedText.contains("cloudy") {
            return "Cloudy"
        } else if correctedText.contains("overcast") {
            return "Overcast"
        } else if correctedText.contains("rain") || correctedText.contains("drizzle") {
            return "Rain"
        } else if correctedText.contains("snow") {
            return "Snow"
        } else if correctedText.contains("fog") {
            return "Fog"
        } else if correctedText.contains("mist") {
            return "Mist"
        } else if correctedText.contains("clear") {
            return "Clear"
        } else if correctedText.contains("sunny") {
            return "Sunny"
        } else if correctedText.contains("ice") {
            return "Hail"
        } else if correctedText.contains("sleet") {
            return "Sleet"
        } else if correctedText.contains("blizzard") {
            return "Blizzard"
        } else if correctedText.contains("thunder") {
            return "Thunder"
        } else {
            return correctedText
        }
    }

    static func getMediumCondition(from text: String) -> String {
        let correctedText = text.split(separator: " in ", omittingEmptySubsequences: true).first?.description
        switch correctedText {
        case "Sunny":
            return "Sunny"
        case "Partly cloudy":
            return "Partly Cloudy"
        case "Cloudy":
            return "Cloudy"
        case "Overcast":
            return "Overcast"
        case "Mist":
            return "Mist"
        case "Patchy rain possible":
            return "Patchy Rain"
        case "Patchy snow possible":
            return "Patchy Snow"
        case "Patchy sleet possible":
            return "Patchy Sleet"
        case "Patchy freezing drizzle possible":
            return "Patchy F Drizzle"
        case "Thundery outbreaks possible":
            return "Thunder"
        case "Thundery outbreaks":
            return "Thunder"
        case "Blowing snow":
            return "Blowing Snow"
        case "Blizzard":
            return "Blizzard"
        case "Fog":
            return "Fog"
        case "Freezing fog":
            return "Freezing Fog"
        case "Patchy light drizzle":
            return "P,L Drizzle"
        case "Light drizzle":
            return "Light Drizzle"
        case "Freezing drizzle":
            return "Freezing Drizzle"
        case "Heavy freezing drizzle":
            return "H,F Drizzle"
        case "Patchy light rain":
            return "Patchy L Rain"
        case "Light rain":
            return "Light Rain"
        case "Moderate rain at times":
            return "Moderate Rain"
        case "Moderate rain":
            return "Moderate Rain"
        case "Heavy rain at times":
            return "Heavy Rain"
        case "Heavy rain":
            return "Heavy Rain"
        case "Light freezing rain":
            return "Light F Rain"
        case "Moderate or heavy freezing rain":
            return "M/H Rain"
        case "Light sleet":
            return "Light Sleet"
        case "Moderate or heavy sleet":
            return "M/H Sleet"
        case "Patchy light snow":
            return "Patchy L Snow"
        case "Light snow":
            return "Light Snow"
        case "Patchy moderate snow":
            return "Patchy M Snow"
        case "Moderate snow":
            return "Moderate Snow"
        case "Patchy heavy snow":
            return "Patchy H Snow"
        case "Heavy snow":
            return "Heavy Snow"
        case "Ice pellets":
            return "Ice Pellets"
        case "Light rain shower":
            return "L Rain Sh"
        case "Moderate or heavy rain shower":
            return "M/H Rain Sh"
        case "Torrential rain shower":
            return "Torrential Rain Sh"
        case "Light sleet showers":
            return "Light Sleet Sh"
        case "Moderate or heavy sleet showers":
            return "M/H Sleet Sh"
        case "Light snow showers":
            return "Light Snow Sh"
        case "Moderate or heavy snow showers":
            return "M/H Snow Sh"
        case "Light showers of ice pellets":
            return "L Ice Pellet Sh"
        case "Moderate or heavy showers of ice pellets":
            return "M/H Ice Pellet Sh"
        case "Patchy light rain with thunder":
            return "P,L Rain & Thunder"
        case "Moderate or heavy rain with thunder":
            return "M/H Rain & Thunder"
        case "Patchy light snow with thunder":
            return "L,P Snow & Thunder"
        case "Moderate or heavy snow with thunder":
            return "H Snow & Thunder"
        default:
            return correctedText ?? ""
        }
    }
}

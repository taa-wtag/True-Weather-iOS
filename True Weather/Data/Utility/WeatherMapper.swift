import Foundation

extension HourlyWeatherData {
    func toCurrentWeather() -> HourlyWeatherItem {
        let currentWeather = HourlyWeatherItem()
        if let timeNow = timeEpoch {
            currentWeather.timeEpoch = Date(timeIntervalSince1970: Double(timeNow))
        }
        currentWeather.timeString = timeString
        currentWeather.tempC = tempC
        currentWeather.tempF = tempF
        currentWeather.feelsLikeC = feelsLikeC
        currentWeather.feelsLikeF = feelsLikeF
        currentWeather.visKm = visKm
        currentWeather.visMiles = visMiles
        currentWeather.windKph = windKph
        currentWeather.windMph = windMph
        currentWeather.humidity = humidity
        currentWeather.isDay = isDay
        currentWeather.conditionText = weatherCondition?.text
        return currentWeather
    }
}

extension DailyForecastData {
    func toHourlyForecaseWeather() -> [HourlyWeatherItem] {
        return hourlyWeatherDataList?.map { (hourlyData) in
            hourlyData.toCurrentWeather()
        } ?? []
    }
}

extension DailyForecastData {
    func toDailyForecaseWeather() -> DailyWeatherItem {
        let weatherToday = DailyWeatherItem()
        if let date = dateEpoch {
            weatherToday.dateEpoch = Date(timeIntervalSince1970: Double(date))
        }
        weatherToday.dateString = dateString
        weatherToday.minTempC = dailyWeatherData?.minTempC
        weatherToday.minTempF = dailyWeatherData?.minTempF
        weatherToday.maxTempC = dailyWeatherData?.maxTempC
        weatherToday.maxTempF = dailyWeatherData?.maxTempF
        weatherToday.avgTempC = dailyWeatherData?.avgTempC
        weatherToday.avgTempF = dailyWeatherData?.avgTempF
        weatherToday.avgVisKm = dailyWeatherData?.avgVisKm
        weatherToday.avgVisMiles = dailyWeatherData?.avgVisMiles
        weatherToday.maxWindKph = dailyWeatherData?.maxWindKph
        weatherToday.maxWindMph = dailyWeatherData?.maxWindMph
        weatherToday.avgHumidity = dailyWeatherData?.avgHumidity
        weatherToday.conditionText = dailyWeatherData?.weatherCondition?.text
        return weatherToday
    }
}

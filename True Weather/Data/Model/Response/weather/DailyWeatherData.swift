import Foundation

struct DailyWeatherData: Decodable {
    let avgHumidity: Int?
    let avgTempC: Double?
    let avgTempF: Double?
    let avgVisKm: Double?
    let avgVisMiles: Double?
    let weatherCondition: WeatherCondition?
    let maxTempC: Double?
    let maxTempF: Double?
    let maxWindKph: Double?
    let maxWindMph: Double?
    let minTempC: Double?
    let minTempF: Double?

    private enum CodingKeys: String, CodingKey {
        case avgHumidity = "avghumidity"
        case avgTempC = "avgtemp_c"
        case avgTempF = "avgtemp_f"
        case avgVisKm = "avgvis_km"
        case avgVisMiles = "avgvis_miles"
        case weatherCondition = "condition"
        case maxTempC = "maxtemp_c"
        case maxTempF = "maxtemp_f"
        case maxWindKph = "maxwind_kph"
        case maxWindMph = "maxwind_mph"
        case minTempC = "mintemp_c"
        case minTempF = "mintemp_f"
    }

    init(
        weatherCondition: WeatherCondition? = nil,
        avgTempC: Double? = nil,
        avgTempF: Double? = nil,
        avgHumidity: Int? = nil,
        maxTempC: Double? = nil,
        maxTempF: Double? = nil,
        minTempC: Double? = nil,
        minTempF: Double? = nil,
        avgVisKm: Double? = nil,
        avgVisMiles: Double? = nil,
        maxWindKph: Double? = nil,
        maxWindMph: Double? = nil
    ) {
    self.weatherCondition = weatherCondition
    self.avgTempC = avgTempC
    self.avgTempF = avgTempF
    self.avgHumidity = avgHumidity
    self.maxTempC = maxTempC
    self.maxTempF = maxTempF
    self.minTempC = minTempC
    self.minTempF = minTempF
    self.avgVisKm = avgVisKm
    self.avgVisMiles = avgVisMiles
    self.maxWindKph = maxWindKph
    self.maxWindMph = maxWindMph
    }
}

import Foundation

struct HourlyWeatherData: Decodable, Identifiable {
    var id: Int { timeEpoch ?? 0 }
    let weatherCondition: WeatherCondition?
    let feelsLikeC: Double?
    let feelsLikeF: Double?
    let humidity: Int?
    let isDay: Int?
    let tempC: Double?
    let tempF: Double?
    let timeString: String?
    let timeEpoch: Int?
    let visKm: Double?
    let visMiles: Double?
    let windKph: Double?
    let windMph: Double?
    
    private enum CodingKeys : String, CodingKey {
        case weatherCondition = "condition"
        case feelsLikeC = "feelslike_c"
        case feelsLikeF = "feelslike_f"
        case humidity
        case isDay = "is_day"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case timeString = "time"
        case timeEpoch = "time_epoch"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case windKph = "wind_kph"
        case windMph = "wind_mph"
        case alternateTimeString = "last_updated"
        case alternateTimeEpoch = "last_updated_epoch"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            weatherCondition = try? container.decode(WeatherCondition.self, forKey: .weatherCondition)
            feelsLikeC = try? container.decode(Double.self, forKey: .feelsLikeC)
            feelsLikeF = try? container.decode(Double.self, forKey: .feelsLikeF)
            humidity = try? container.decode(Int.self, forKey: .humidity)
            isDay = try? container.decode(Int.self, forKey: .isDay)
            tempC = try? container.decode(Double.self, forKey: .tempC)
            tempF = try? container.decode(Double.self, forKey: .tempF)
            visKm = try? container.decode(Double.self, forKey: .visKm)
            visMiles = try? container.decode(Double.self, forKey: .visMiles)
            windKph = try? container.decode(Double.self, forKey: .windKph)
            windMph = try? container.decode(Double.self, forKey: .windMph)

            if let timeString = try? container.decode(String.self, forKey: .timeString) {
                self.timeString = timeString
            } else {
                self.timeString = try? container.decode(String.self, forKey: .alternateTimeString)
            }

            if let timeEpoch = try? container.decode(Int.self, forKey: .timeEpoch) {
                self.timeEpoch = timeEpoch
            } else {
                self.timeEpoch = try? container.decode(Int.self, forKey: .alternateTimeEpoch)
            }
        }
}

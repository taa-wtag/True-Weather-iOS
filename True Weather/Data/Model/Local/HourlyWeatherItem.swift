import Foundation
import RealmSwift

class HourlyWeatherItem: Object{
    @Persisted var timeEpoch: Date?
    @Persisted var timeString: String?
    @Persisted var tempC: Double?
    @Persisted var tempF: Double?
    @Persisted var feelsLikeC: Double?
    @Persisted var feelsLikeF: Double?
    @Persisted var visKm: Double?
    @Persisted var visMiles: Double?
    @Persisted var windKph: Double?
    @Persisted var windMph: Double?
    @Persisted var humidity: Int?
    @Persisted var isDay: Int?
    @Persisted var conditionText: String?
    @Persisted var imageUrl: String?
}

import Foundation
import RealmSwift

class DailyWeatherItem: Object {
    @Persisted var dateEpoch: Date?
    @Persisted var dateString: String?
    @Persisted var minTempC: Double?
    @Persisted var minTempF: Double?
    @Persisted var maxTempC: Double?
    @Persisted var maxTempF: Double?
    @Persisted var avgTempC: Double?
    @Persisted var avgTempF: Double?
    @Persisted var avgVisKm: Double?
    @Persisted var avgVisMiles: Double?
    @Persisted var maxWindKph: Double?
    @Persisted var maxWindMph: Double?
    @Persisted var avgHumidity: Int?
    @Persisted var conditionText: String?
    @Persisted var image: Data?
}

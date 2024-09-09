import Foundation
import RealmSwift

class CityItem: Object{
    @Persisted(primaryKey: true) var cityName: String?
    @Persisted var backgroundColor: Int?
    @Persisted var weatherEveryDay = List<DailyWeatherItem>()
    @Persisted var weatherEveryHour = List<HourlyWeatherItem>()
}

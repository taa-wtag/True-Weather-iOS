import Foundation
import RealmSwift

class WeatherIconItem: Object {
    @Persisted(primaryKey: true) var url: String?
    @Persisted var imageData: Data?
}

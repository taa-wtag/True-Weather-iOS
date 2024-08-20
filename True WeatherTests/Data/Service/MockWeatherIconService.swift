import Foundation
@testable import True_Weather

class MockWeatherIconService: WeatherIconServiceProtocol {
    var imageData: Data?
    var hasIconInCache = false
    var saveIconCalled = false

    func getIconFromRemote(url: String, completion: @escaping (Data) -> Void) {
        hasIconInCache = true
        completion(imageData!)
    }

    func getIconFromCache(url: String, completion: @escaping (Data?) -> Void) {
        if hasIconInCache {
            completion(imageData)
        } else {
            completion(nil)
        }
    }

    func saveIcon(url: String, image: Data) {
        saveIconCalled = true
    }
}

import Foundation
import UIKit

protocol WeatherIconServiceProtocol {
    func getIconFromRemote(url: String, completion: @escaping(UIImage) -> Void)
    func getIconFromcache(url: String, completion: @escaping(UIImage?) -> Void)
    func saveIcon(image: WeatherIconItem)
}

class WeatherIconService: WeatherIconServiceProtocol {
    static let shared = WeatherIconService()
    private let networkRequestService = NetworkRequestService.sharedInstance
    private let database = DatabaseManager.sharedInstance

    private init() {}

    func getIconFromRemote(url: String, completion: @escaping(UIImage) -> Void) {
        networkRequestService.request(url) { _, data in
            if let image = data {
                completion(image)
            }
        }
    }

    func getIconFromcache(url: String, completion: @escaping(UIImage?) -> Void) {
        if let icon = database.get(
            WeatherIconItem.self,
            predicate: { $0.url == url }
        )?.imageData, let image = UIImage(data: icon) {
            completion(image)
        } else {
            completion(nil)
        }
    }

    func saveIcon(image: WeatherIconItem) {
        database.update(image)
    }
}

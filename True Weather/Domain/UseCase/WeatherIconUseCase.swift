import Foundation
import UIKit

struct WeatherIconUseCase {
    private let service: WeatherIconServiceProtocol

    init(service: WeatherIconServiceProtocol = WeatherIconService.shared) {
        self.service = service
    }

    func loadWeatherIcon(from url: String, completion: @escaping(UIImage) -> Void) {
        service.getIconFromcache(url: url) { data in
            if let image = data {
                completion(image)
            } else {
                getWeatherIconFromRemote(from: url) {
                    loadWeatherIcon(from: url) {completion($0)}
                }
            }
        }
    }

    private func getWeatherIconFromRemote(from url: String, completion: @escaping() -> Void) {
        service.getIconFromRemote(url: url) { data in
            let image = WeatherIconItem()
            image.url = url
            image.imageData = data.pngData()
            service.saveIcon(image: image)
            completion()
        }
    }
}

import Foundation
import UIKit

struct WeatherIconUseCase {
    private let service: WeatherIconServiceProtocol

    init(service: WeatherIconServiceProtocol = WeatherIconService.shared) {
        self.service = service
    }

    func loadWeatherIcon(from url: String, completion: @escaping(Data) -> Void) {
        service.getIconFromCache(url: url) { data in
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
        service.getIconFromRemote(url: Constants.Weather.IconBaseUrl + url) { data in
            service.saveIcon(url: url, image: data)
            completion()
        }
    }
}

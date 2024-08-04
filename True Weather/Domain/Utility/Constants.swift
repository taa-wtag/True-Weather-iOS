import Foundation

struct Constants {

    struct Mapbox {
        static let MapboxBaseUrl = "https://api.mapbox.com/"
        static let SearchLimit = 5
        static let SessionToken =  UUID().uuidString
    }

    struct Weather {
        static let WeatherBaseUrl = "https://api.weatherapi.com/v1/"
        static let ForecastMaxDays = 3
    }
}

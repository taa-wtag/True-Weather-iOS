import Foundation
import UIKit

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

    struct Segues {
        static let ShowCities = "ShowCities"
        static let ShowCitySearch = "ShowCitySearch"
    }

    struct CellIdentifiers {
        static let CityItem = "CityItemCell"
        static let CityPage = "CityPageCell"
        static let HourlyWeather = "HourlyWeatherCell"
        static let DailyWeather = "DailyWeatherCell"
        static let SearchCity = "SearchCityCell"
        static let CollectionViewInTableView = "CollectionViewTableViewCell"
        static let HeaderTableView = "HeaderTableViewCell"
    }

    struct Colors {
        static let Black = "BlackNew"
        static let DarkGrey = "DarkGrey"
        static let LightGrey = "LightGrey"
        static let DeepGolden = "DeepGolden"
        static let LightGolden = "LightGolden"
        static let White = "WhiteNew"
    }

    static var sizeMagnifier: CGFloat {
        return UIScreen.main.bounds.size.width / 375.0
    }
}

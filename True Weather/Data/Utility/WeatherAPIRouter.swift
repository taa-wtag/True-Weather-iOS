import Foundation
import Alamofire

enum WeatherAPIRouter: URLRequestConvertible {

    case getCurrentWeather (from: WeatherQuery)
    case getWeatherForecast (from: WeatherQuery)
    case getCityName (from: WeatherQuery)
    case searchCity (from: WeatherQuery)

    var path: String {
        switch self {
        case .getCurrentWeather:
            return "current.json"
        case .getWeatherForecast:
            return "forecast.json"
        case .getCityName, .searchCity:
            return "search.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCurrentWeather, .getWeatherForecast, .getCityName, .searchCity:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getCurrentWeather(let params),
                .searchCity(let params),
                .getWeatherForecast(let params),
                .getCityName(let params):
            return params.parameters().isEmpty ? nil : params.parameters()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.Weather.WeatherBaseUrl.asURL()
            .appendingPathComponent(path)
            .absoluteString.removingPercentEncoding!)
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

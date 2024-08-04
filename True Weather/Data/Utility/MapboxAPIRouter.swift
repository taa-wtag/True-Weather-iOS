import Foundation
import Alamofire

enum MapboxAPIRouter: URLRequestConvertible {

    case getPlaceSuggestions (from: MapboxQuery)

    var path: String {
        switch self {
        case .getPlaceSuggestions:
            return "search/searchbox/v1/suggest"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPlaceSuggestions:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getPlaceSuggestions(let params):
            return params.parameters().isEmpty ? nil : params.parameters()
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: Constants.Mapbox.MapboxBaseUrl.asURL()
            .appendingPathComponent(path)
            .absoluteString.removingPercentEncoding!)

        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

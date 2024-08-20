import Foundation
import Alamofire
import AlamofireImage

protocol NetworkRequestServiceProtocol {
    func request<T: Decodable> (
        _ request: URLRequestConvertible,
        responseType: T.Type,
        completion: @escaping(_ error: String?, _ data: T?) -> Void
    )
    func request (
        _ request: String,
        completion: @escaping(_ error: String?, _ data: Image?) -> Void
    )
}

class NetworkRequestService: NetworkRequestServiceProtocol {

    static let sharedInstance = NetworkRequestService.init()

    private init() {}

    func request<T: Decodable> (
        _ request: URLRequestConvertible,
        responseType: T.Type,
        completion: @escaping(_ error: String?, _ data: T?) -> Void
    ) {

        guard NetworkState.isConnected() else {
            let error = "No Connection"
            completion(error, nil)
            return
        }

        AF.request(request).responseDecodable(of: responseType) { response in
            self.handleResponse(response: response) { error, data in
                completion(error, data)
            }
        }
    }

    func request(_ request: String, completion: @escaping (String?, Image?) -> Void) {

        guard NetworkState.isConnected() else {
            let error = "No Connection"
            completion(error, nil)
            return
        }

        AF.request(request).responseImage { response in
            self.handleResponse(response: response) { error, data in
                completion(error, data)
            }
        }
    }

    private func handleResponse<T> (
        response: DataResponse<T, AFError>,
        completion: @escaping( _ error: String?, _ data: T? ) -> Void
    ) {
        switch response.result {
        case .failure(let error):
            if error._code == NSURLErrorTimedOut {
                completion("Timeout", nil)
            } else if error._code == 53 {
                completion("Connection Lost", nil)
            } else {
                completion("Unknown Error", nil)
            }
            return

        case .success:
            do {
                try completion(nil, response.result.get())
            } catch {
                completion(error.localizedDescription, nil)
            }
            return
        }
    }
}

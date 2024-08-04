import Alamofire

protocol NetworkStateProtocol {
    func isNetworkConnected() -> Bool
}

class NetworkState: NetworkStateProtocol {
    static let shared = NetworkState()

    func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    class func isConnected() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestAuthorization()
    func isAuthorized() -> Bool
    func requestLocationOnce()
}

protocol LocationServiceDelegate: AnyObject {
    func didFetchLocation(latitude: Double, longitude: Double)
}

class LocationService: NSObject, LocationServiceProtocol {
    static let shared = LocationService()

    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    private override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func isAuthorized() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    func requestLocationOnce() {
        if isAuthorized() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            delegate?.didFetchLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}

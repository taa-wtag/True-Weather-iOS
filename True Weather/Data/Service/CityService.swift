import Foundation

protocol CityServiceProtocol {
    func searchForPlaces(with query: String, completion: @escaping(String?, [CitySuggestion]?) -> Void)

    func getCityNameFromLocation(
        from query: (latitude: Double, longitude: Double),
        completion: @escaping(String?, [CityData]?) -> Void
    )

    func addCity(city: CityItem)

    func deleteCity(city: CityItem)

    func getCity(name city: String, completion: @escaping(CityItem?) -> Void)

    func getAllCities(completion: @escaping([CityItem]?) -> Void)
}

class CityService: CityServiceProtocol {
    static let shared = CityService()
    private let networkRequestService = NetworkRequestService.sharedInstance
    private let database = DatabaseManager.sharedInstance

    private init() {}

    func searchForPlaces(with query: String, completion: @escaping (String?, [CitySuggestion]?) -> Void) {
        let query = MapboxQuery(searchQuery: query)
        let request = MapboxAPIRouter.getPlaceSuggestions(from: query)
        networkRequestService.request(request, responseType: SearchResponse.self) { error, data in
            if error == nil, let suggestions = data?.citySuggestions {
                completion(error, suggestions)
            } else {
                completion(error, nil)
            }
        }
    }

    func getCityNameFromLocation(
        from query: (latitude: Double, longitude: Double),
        completion: @escaping(String?, [CityData]?) -> Void
    ) {
        let query = WeatherQuery(locationCoordinates: query)
        let request = WeatherAPIRouter.searchCity(from: query)
        networkRequestService.request(request, responseType: [CityData].self) { error, data in
            if error == nil, let suggestions = data {
                completion(error, suggestions)
            } else {
                completion(error, nil)
            }
        }
    }

    func addCity(city: CityItem) {
        database.save(city)
    }

    func deleteCity(city: CityItem) {
        database.delete(city)
    }

    func getCity(name city: String, completion: @escaping (CityItem?) -> Void) {
        let cityItem = database.get(CityItem.self) { $0.cityName == city }
        completion(cityItem)
    }

    func getAllCities(completion: @escaping ([CityItem]?) -> Void) {
        let cities = database.getAll(CityItem.self)
        completion(cities)
    }
}

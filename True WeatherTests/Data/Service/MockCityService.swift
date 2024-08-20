import Foundation
@testable import True_Weather

class MockCityService: CityServiceProtocol {
    var errorMessage: String?
    var cityDataList: [CityData]?
    var suggestionList: [CitySuggestion]?
    var cityList: [CityItem]?
    var city: CityItem?
    var addCityCalled = false
    var hasError = false

    func searchForPlaces(
        with query: String,
        completion: @escaping (String?, [CitySuggestion]?) -> Void
    ) {
         if !hasError {
            completion(nil, suggestionList!)
        } else {
            completion(errorMessage!, nil)
        }
    }

    func getCityNameFromLocation(
        from query: (latitude: Double, longitude: Double),
        completion: @escaping (String?, [CityData]?) -> Void
    ) {
        if !hasError {
           completion(nil, cityDataList!)
       } else {
           completion(errorMessage!, nil)
       }
    }

    func addCity(city: CityItem) {
        addCityCalled = true
    }

    func deleteCity(city: String, completion: @escaping () -> Void) {
        cityList = []
        completion()
    }

    func getCity(name city: String, completion: @escaping (CityItem?) -> Void) {
        if !hasError {
           completion(nil)
       } else {
           completion(self.city!)
       }
    }

    func getAllCities(completion: @escaping ([CityItem]) -> Void) {
        if !hasError {
           completion([])
       } else {
           completion(cityList!)
       }
    }
}

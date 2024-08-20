import Foundation
@testable import True_Weather

class MockCitySearchViewModelDataHelper {
    func citySuggestions() -> [CitySuggestion] {
        return [
            CitySuggestion(
                placeData: PlaceData(countryData: CountryData(countryName: "Bangladesh")),
                cityName: "Dhaka"
            )
        ]
    }
}

@testable import True_Weather

class MockCitySearchViewModelDataHelper {
    func citySuggestions() -> [CitySuggestion] {
        return [
            CitySuggestion(
                placeData: PlaceData(countryData: CountryData(countryName: "Bangladesh")),
                cityName: "Dhaka"
            ),
            CitySuggestion(
                placeData: PlaceData(countryData: CountryData(countryName: "Japan")),
                cityName: "Tokyo"
            ),
            CitySuggestion( placeData: nil, cityName: nil )
        ]
    }

    func errorMessage() -> String {"Something unexepected ocurred."}

    func cityItem() -> CityItem {CityItem()}
}

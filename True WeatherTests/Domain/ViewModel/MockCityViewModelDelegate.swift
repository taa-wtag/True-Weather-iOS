@testable import True_Weather

class MockCityViewModelDelegate: CityViewModelDelegate {
    var didFinishLoadingCitiesCalled = false

    func didFinishLoadingCities() {
        didFinishLoadingCitiesCalled = true
    }
}

import Foundation
@testable import True_Weather

class MockCitySearchViewModelDelegate: CitySearchViewModelDelegate {
    var didFinishAddingCityCalled = false
    var didFinishLoadingCalled = false

    func didFinishAddingCity() {
        didFinishAddingCityCalled = true
    }

    func didFinishLoading() {
        didFinishLoadingCalled = true
    }
}

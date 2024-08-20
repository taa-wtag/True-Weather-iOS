import XCTest
@testable import True_Weather

final class CitySearchViewModelTest: XCTestCase {
    var sut: CitySearchViewModel!
    var mockService: CityServiceProtocol!
    var mockDataHelper: MockCitySearchViewModelDataHelper!
    var mockDelegate: MockCitySearchViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockService = MockCityService()
        mockDataHelper = MockCitySearchViewModelDataHelper()
        mockDelegate = MockCitySearchViewModelDelegate()
        sut = CitySearchViewModel(service: mockService)
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockDataHelper = nil
        super.tearDown()
    }

    func test_Example() {
        
    }

}

import XCTest
@testable import True_Weather

final class CitySearchViewModelTest: XCTestCase {
    var sut: CitySearchViewModel!
    var mockService: MockCityService!
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
        mockDelegate = nil
        mockDataHelper = nil
        super.tearDown()
    }

    func test_searchForCities_withVaildString() {
        let suggestions = mockDataHelper.citySuggestions()
        mockService.suggestionList = suggestions

        XCTAssertEqual(sut.cityArray, [])

        sut.searchForCities(with: "test")

        XCTAssertEqual(sut.cityArray, ["Dhaka, Bangladesh", "Tokyo, Japan"])
        XCTAssertEqual(mockDelegate.didFinishLoadingCalled, true)
    }

    func test_searchForCities_error() {
        mockService.errorMessage = mockDataHelper.errorMessage()
        mockService.hasError = true

        sut.searchForCities(with: "test")

        XCTAssertEqual(sut.cityArray, [])
        XCTAssertEqual(sut.errorMessage, "Something unexepected ocurred.")
        XCTAssertEqual(mockDelegate.didFinishLoadingCalled, false)
    }

    func test_addCity_withValidCity() {
        let suggestions = mockDataHelper.citySuggestions()
        mockService.suggestionList = suggestions

        sut.searchForCities(with: "test")

        mockService.hasCityInCache = false

        sut.addCity(withIndex: 1)

        XCTAssertEqual(mockService.city?.cityName, "Tokyo, Japan")
        XCTAssertEqual(mockDelegate.didFinishAddingCityCalled, true)
    }

    func test_addCity_cityAlreadyExists() {
        let suggestions = mockDataHelper.citySuggestions()
        mockService.suggestionList = suggestions
        mockService.city = mockDataHelper.cityItem()

        sut.searchForCities(with: "test")

        mockService.hasCityInCache = true

        sut.addCity(withIndex: 0)

        XCTAssertEqual(mockService.city?.cityName, nil)
        XCTAssertEqual(mockDelegate.didFinishAddingCityCalled, false)
    }

}

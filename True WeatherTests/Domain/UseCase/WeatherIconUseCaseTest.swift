import XCTest
@testable import True_Weather

class WeatherIconUseCaseTest: XCTestCase {
    var sut: WeatherIconUseCase!
    var mockService: MockWeatherIconService!
    var mockDataHelper: MockWeatherIconUseCaseDataHelper!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherIconService()
        mockDataHelper = MockWeatherIconUseCaseDataHelper()
        sut = WeatherIconUseCase(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockDataHelper = nil
        super.tearDown()
    }

    func test_loadWeatherIcon_cachedData() {
        mockService.hasIconInCache = true
        mockService.imageData = mockDataHelper.imageData()
        var returnedData: Data?

        sut.loadWeatherIcon(from: "") { data in
            returnedData = data
        }

        XCTAssertEqual(returnedData, mockDataHelper.imageData())
    }

    func test_loadWeatherIcon_remoteData() {
        mockService.hasIconInCache = false
        mockService.imageData = mockDataHelper.imageData()
        var returnedData: Data?

        sut.loadWeatherIcon(from: "") { data in
            returnedData = data
        }

        XCTAssertEqual(returnedData, mockDataHelper.imageData())
        XCTAssertEqual(mockService.saveIconCalled, true)
    }
}

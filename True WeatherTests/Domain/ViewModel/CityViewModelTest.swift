import XCTest
@testable import True_Weather

final class CityViewModelTest: XCTestCase {
    var sut: CityViewModel!
    var mockCityService: MockCityService!
    var mockWeatherService: MockWeatherService!
    var mockDataHelper: MockCityViewModelDataHelper!
    var mockDelegate: MockCityViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockCityService = MockCityService()
        mockWeatherService = MockWeatherService()
        mockDataHelper = MockCityViewModelDataHelper()
        mockDelegate = MockCityViewModelDelegate()
        sut = CityViewModel(
            cityService: mockCityService,
            weatherService: mockWeatherService,
            delegate: mockDelegate
        )
    }

    override func tearDown() {
        sut = nil
        mockCityService = nil
        mockWeatherService = nil
        mockDelegate = nil
        mockDataHelper = nil
        super.tearDown()
    }

    func test_getAllCities_loadsCities() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hourlyWeatherList = [mockDataHelper.currentWeather()]

        sut.getAllCities()

        XCTAssertEqual(sut.cityList.count, 2)
        XCTAssertEqual(sut.cityList.first?.cityName, "Dhaka, Bangladesh")
        XCTAssertEqual(mockDelegate.didFinishLoadingCitiesCalled, true)
    }

    func test_getAllCities_loadsCachedWeatherData() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hourlyWeatherList = [mockDataHelper.currentWeather()]

        sut.getAllCities()

        XCTAssertEqual(sut.currentWeatherList["Dhaka, Bangladesh"]?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockDelegate.didFinishLoadingCitiesCalled, true)
    }

    func test_getAllCities_fetchesWeatherDataForOldData() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = [mockDataHelper.expiredCurrentWeather()]
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.newCurrentWeather = mockDataHelper.currentWeather()

        sut.getAllCities()

        XCTAssertEqual(sut.currentWeatherList["Dhaka, Bangladesh"]?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 2)
    }

    func test_getAllCities_fetchesWeatherDataForNonCurrentData() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = [mockDataHelper.futureCurrentWeather()]
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.newCurrentWeather = mockDataHelper.currentWeather()

        sut.getAllCities()

        XCTAssertEqual(sut.currentWeatherList["Dhaka, Bangladesh"]?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 2)
    }

    func test_getAllCities_fetchesWeatherDataForNoCachedData() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hourlyWeatherList = [mockDataHelper.currentWeather()]
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()

        sut.getAllCities()

        XCTAssertEqual(mockWeatherService.addWeatherCount, 2)
    }

    func test_getAllCities_failsToFetchWeatherData() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hasError = true
        mockWeatherService.errorMessage = "Error"
        mockWeatherService.hourlyWeatherList = [mockDataHelper.currentWeather()]

        sut.getAllCities()

        XCTAssertEqual(sut.currentWeatherList["Dhaka, Bangladesh"]?.timeString, nil)
        XCTAssertEqual(mockWeatherService.addWeatherCount, 0)
        XCTAssertEqual(sut.errorMessage, "Error")
    }

    func test_deleteCity_deleteExistingCity() {
        mockCityService.cityList = mockDataHelper.cityList()

        sut.getAllCities()

        mockDelegate.didFinishLoadingCitiesCalled = false

        sut.deleteCity(at: 1)

        XCTAssertEqual(sut.cityList, [])
        XCTAssertNil(sut.currentWeatherList["Tokyo, Japan"])
        XCTAssertEqual(mockDelegate.didFinishLoadingCitiesCalled, true)
    }

    func test_deleteCity_error() {
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hourlyWeatherList = [mockDataHelper.currentWeather()]

        sut.getAllCities()

        mockDelegate.didFinishLoadingCitiesCalled = false
        mockCityService.hasError = true

        sut.deleteCity(at: 1)

        XCTAssertEqual(sut.cityList.count, 2)
        XCTAssertEqual(sut.currentWeatherList["Tokyo, Japan"]?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockDelegate.didFinishLoadingCitiesCalled, false)
    }
}

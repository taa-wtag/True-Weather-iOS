import XCTest
@testable import True_Weather

final class WeatherViewModelTest: XCTestCase {
    var sut: WeatherViewModel!
    var mockCityService: MockCityService!
    var mockWeatherService: MockWeatherService!
    var mockLocationService: MockLocationService!
    var mockDataHelper: MockWeatherViewModelDataHelper!
    var mockDelegate: MockWeatherViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockCityService = MockCityService()
        mockWeatherService = MockWeatherService()
        mockLocationService = MockLocationService()
        mockDataHelper = MockWeatherViewModelDataHelper()
        mockDelegate = MockWeatherViewModelDelegate()
        sut = WeatherViewModel(
            cityService: mockCityService,
            weatherService: mockWeatherService,
            locationService: mockLocationService,
            delegate: mockDelegate
        )
    }

    override func tearDown() {
        sut = nil
        mockCityService = nil
        mockWeatherService = nil
        mockLocationService = nil
        mockDelegate = nil
        mockDataHelper = nil
        super.tearDown()
    }

    func test_getAllCities_loadsCities() {
        mockWeatherService.hasCachedWeather = true
        mockCityService.cityList = mockDataHelper.cityList()

        sut.getAllCities()

        XCTAssertEqual(sut.cityList.count, 2)
        XCTAssertEqual(sut.cityList.first?.cityName, "Dhaka, Bangladesh")
        XCTAssertEqual(mockDelegate.didFinishLoadingCitiesCalled, true)
    }

    func test_setCurrentCity_updatesCurrentCity() {
        mockWeatherService.hasCachedWeather = true
        mockCityService.cityList = mockDataHelper.cityList()

        sut.getAllCities()

        sut.setCurrentCity(index: 0)

        XCTAssertEqual(sut.currentCity?.cityName, "Dhaka, Bangladesh")
        XCTAssertEqual(mockDelegate.didUpdateCurrentCityCalled, true)
    }

    func test_setCurrentCity_loadsWeatherData() {
        mockWeatherService.hasCachedWeather = true
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()

        sut.getAllCities()

        sut.setCurrentCity(index: 0)

        XCTAssertEqual(sut.hourlyWeatherList.count, 23)
        XCTAssertEqual(sut.dailyWeatherList.count, 9)
    }

    func test_setCurrentCity_resetsDataForInvalidIndex() {
        mockWeatherService.hasCachedWeather = true
        mockCityService.cityList = mockDataHelper.cityList()
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()

        sut.getAllCities()

        sut.setCurrentCity(index: 0)

        sut.setCurrentCity(index: 3)

        XCTAssertNil(sut.currentCity)
        XCTAssertEqual(sut.dailyWeatherList.count, 0)
        XCTAssertEqual(sut.hourlyWeatherList.count, 0)
    }

    func test_loadCurrentWeatherData_loadscachedWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()

        sut.loadCurrentWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.currentWeather?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 0)
    }

    func test_loadCurrentWeatherData_fetchesWeatherForOldCachedWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = [mockDataHelper.expiredCurrentWeather()]
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.newCurrentWeather = mockDataHelper.currentWeather()

        sut.loadCurrentWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.currentWeather?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 1)
    }

    func test_loadCurrentWeatherData_fetchesWeatherForNonCurrentCachedWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = [mockDataHelper.futureCurrentWeather()]
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.newCurrentWeather = mockDataHelper.currentWeather()

        sut.loadCurrentWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.currentWeather?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 1)
        XCTAssertEqual(mockDelegate.didUpdateCurrentWeatherCalled, true)
    }

    func test_loadCurrentWeatherData_fetchesWeather() {
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()

        sut.loadCurrentWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.currentWeather?.timeString, "2020-01-01 02:00")
        XCTAssertEqual(mockWeatherService.addWeatherCount, 1)
        XCTAssertEqual(mockDelegate.didUpdateCurrentWeatherCalled, true)
    }

    func test_loadCurrentWeatherData_failsWithApiError() {
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hasError = true
        mockWeatherService.errorMessage = "Error"

        sut.loadCurrentWeatherData(in: mockDataHelper?.city())

        XCTAssertNil(sut.currentWeather)
        XCTAssertEqual(mockWeatherService.addWeatherCount, 0)
        XCTAssertEqual(sut.errorMessage, "Error")
        XCTAssertEqual(mockDelegate.didUpdateCurrentWeatherCalled, false)
    }

    func test_loadForecastWeatherData_loadscachedWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()

        sut.loadForecastWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.hourlyWeatherList.count, 23)
        XCTAssertEqual(sut.dailyWeatherList.count, 9)
        XCTAssertEqual(mockWeatherService.addWeatherCount, 0)
        XCTAssertEqual(mockDelegate.didUpdateForecastWeatherCalled, true)
    }

    func test_loadForecastWeatherData_correctlyFiltersAndSortsCachedHourlyWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()

        sut.loadForecastWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.hourlyWeatherList[0].timeString, "2020-01-01 02:00")
        for count in 1 ..< 23 {
            let countString = String(count+1%24)
            let hour = String(repeating: "0", count: 2 - countString.count).appending(countString)
            XCTAssertEqual(sut.hourlyWeatherList[count].timeString, "2020-01-01 \(hour):00")
        }
    }

    func test_loadForecastWeatherData_correctlySortsCachedDailyWeather() {
        mockWeatherService.hasCachedWeather = true
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()

        sut.loadForecastWeatherData(in: mockDataHelper?.city())

        for count in 1 ..< 10 {
            XCTAssertEqual(sut.dailyWeatherList[count - 1].dateString, "2020-01-0\(count)")
        }
    }

    func test_loadForecastWeatherData_fetchesForecastWeather() {
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hasError = false
        mockWeatherService.hourlyWeatherList = mockDataHelper.hourlyWeatherList()
        mockWeatherService.dailyWeatherList = mockDataHelper.dailyWeatherList()
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.forecastWeatherData = mockDataHelper.forecastWeatherData()

        sut.loadForecastWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.hourlyWeatherList.count, 23)
        XCTAssertEqual(sut.dailyWeatherList.count, 9)
        XCTAssertEqual(mockWeatherService.addWeatherCount, 3)
        XCTAssertEqual(mockDelegate.didUpdateForecastWeatherCalled, true)
    }

    func test_loadForecastWeatherData_failsToFetchWithApiError() {
        mockWeatherService.hasCachedWeather = false
        mockWeatherService.hasError = true
        mockWeatherService.currentWeatherData = mockDataHelper.currentWeatherData()
        mockWeatherService.forecastWeatherData = mockDataHelper.forecastWeatherData()

        sut.loadForecastWeatherData(in: mockDataHelper?.city())

        XCTAssertEqual(sut.hourlyWeatherList.count, 0)
        XCTAssertEqual(sut.dailyWeatherList.count, 0)
        XCTAssertEqual(mockWeatherService.addWeatherCount, 0)
        XCTAssertEqual(mockDelegate.didUpdateForecastWeatherCalled, false)
    }

    func test_getCurrentLocation_isAuthorized() {
        mockLocationService.isAuthorizedBool = true

        sut.getCurrentLocation()

        XCTAssertEqual(mockLocationService.requestLocationOnceCalled, true)
        XCTAssertEqual(mockLocationService.requestAuthorizationCalled, false)
    }

    func test_getCurrentLocation_isNotAuthorized() {
        mockLocationService.isAuthorizedBool = false

        sut.getCurrentLocation()

        XCTAssertEqual(mockLocationService.requestLocationOnceCalled, false)
        XCTAssertEqual(mockLocationService.requestAuthorizationCalled, true)
    }

    func test_didFetchLocation_fetchesAndAddsCity() {
        mockCityService.cityDataList = mockDataHelper.cityDataList()

        sut.didFetchLocation(latitude: 0, longitude: 0)

        XCTAssertEqual(mockCityService.city?.cityName, "Dhaka, Bangladesh")
    }

    func test_didFetchLocation_failsToAddCity() {
        mockCityService.cityDataList = mockDataHelper.cityDataList()
        mockCityService.hasCityInCache = true
        mockCityService.city = mockDataHelper.cityItem()

        sut.didFetchLocation(latitude: 0, longitude: 0)

        XCTAssertNil(mockCityService.city?.cityName)
    }

    func test_didFetchLocation_failsWithApiError() {
        mockCityService.hasError = true
        mockCityService.errorMessage = "Error"

        sut.didFetchLocation(latitude: 0, longitude: 0)

        XCTAssertEqual(sut.errorMessage, "Error")
    }
}

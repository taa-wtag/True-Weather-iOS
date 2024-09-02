import Foundation

protocol CitySearchViewModelDelegate: AnyObject {
    func didFinishAddingCity()
    func didFinishLoading()
}

class CitySearchViewModel {
    private let service: CityServiceProtocol

    private(set) var cityArray: [String] = [] {
        didSet {
            delegate?.didFinishLoading()
        }
    }

    private(set) var errorMessage = ""

    weak var delegate: CitySearchViewModelDelegate?

    init(service: CityServiceProtocol = CityService.shared, delegate: CitySearchViewModelDelegate? = nil) {
        self.service = service
        self.delegate = delegate
    }

    func searchForCities(with query: String) {
        service.searchForPlaces(with: query) { [weak self] error, response in
            if let suggestions = response, error == nil {
                if let cities = self?.citySuggestionsToCityList(suggestions: suggestions) {
                    self?.cityArray = cities
                }
            } else if let errorMessage = error {
                self?.errorMessage = errorMessage
            }
        }
    }

    func addCity(withIndex index: Int) {
        let cityName = cityArray[index]
        service.getCity(name: cityName) { [weak self] city in
            if city == nil {
                let cityItem = CityItem()
                cityItem.cityName = cityName
                cityItem.backgroundColor = Int.random(in: 0..<6)
                self?.service.addCity(city: cityItem)
                self?.delegate?.didFinishAddingCity()
            }
        }
    }

    private func citySuggestionsToCityList(suggestions: [CitySuggestion]) -> [String] {
        return suggestions.compactMap { (city) in
            if let cityName = city.cityName, let countryName = city.placeData?.countryData?.countryName {
                return "\(cityName), \(countryName)"
            } else {
                return nil
            }
        }
    }
}

import Foundation

protocol CitySearchViewModelDelegate: AnyObject {
    func didFinishAddingCity()
    func didFinishLoading()
}

class CitySearchViewModel {
    private let service: CityServiceProtocol

    var cityArray: [String] = [] {
        didSet {
            delegate?.didFinishLoading()
        }
    }

    weak var delegate: CitySearchViewModelDelegate?

    init(service: CityService = CityService.shared, delegate: CitySearchViewModelDelegate? = nil) {
        self.service = service
        self.delegate = delegate
    }

    func searchForCities(with query: String) {
        service.searchForPlaces(with: query) { [weak self] error, response in
            if let suggestions = response, error == nil {
                if let cities = self?.citySuggestionsToCityList(suggestions: suggestions) {
                    self?.cityArray = cities
                }
            }
        }
    }

    func addCity(withIndex index: Int) {
        let cityItem = CityItem()
        cityItem.cityName = cityArray[index]
        cityItem.backgroundColor = Int.random(in: 0..<6)
        service.addCity(city: cityItem)
        delegate?.didFinishAddingCity()
    }

    private func citySuggestionsToCityList(suggestions: [CitySuggestion]) -> [String] {
        return suggestions.map { (city) in
            return "\(city.cityName ?? ""), \(city.placeData?.countryData?.countryName ?? "")"
        }
    }
}

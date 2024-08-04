extension [CityData] {
    func toCityList() -> [String] {
        return self.map { (city) in
            return "\(city.cityName ?? ""), \(city.countryName ?? "")"
        }
    }
}

extension SearchResponse {
    func toCityList() -> [String] {
        return self.citySuggestions?.map { (city) in
            return "\(city.cityName ?? ""), \(city.placeData?.countryData?.countryName ?? "")"
        } ?? []
    }
}

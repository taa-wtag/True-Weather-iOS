extension [CityData] {
    func toCityList() -> [String] {
        return self.map { (city) in
            return "\(city.cityName ?? ""), \(city.countryName ?? "")"
        }
    }
}

extension [CitySuggestion] {
    func toCityList() -> [String] {
        return self.map { (city) in
            return "\(city.cityName ?? ""), \(city.placeData?.countryData?.countryName ?? "")"
        }
    }
}

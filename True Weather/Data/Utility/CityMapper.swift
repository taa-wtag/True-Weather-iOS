extension [CityData] {
    func toCityList() -> [String] {
        return self.map { (city) in
            return "\(city.cityName ?? ""), \(city.countryName ?? "")"
        }
    }
}

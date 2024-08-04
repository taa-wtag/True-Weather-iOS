import Foundation

struct CityData: Decodable, Identifiable {
    var id: String {"\(cityName ?? ""), \(countryName ?? "")"}
    let countryName: String?
    let cityName: String?

    private enum CodingKeys: String, CodingKey {
        case countryName = "country"
        case cityName = "name"
    }
}

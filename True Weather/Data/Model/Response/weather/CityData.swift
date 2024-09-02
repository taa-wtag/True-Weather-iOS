import Foundation

struct CityData: Decodable, Identifiable {
    var id: String {"\(cityName ?? ""), \(countryName ?? "")"}
    let cityName: String?
    let countryName: String?

    private enum CodingKeys: String, CodingKey {
        case countryName = "country"
        case cityName = "name"
    }
}

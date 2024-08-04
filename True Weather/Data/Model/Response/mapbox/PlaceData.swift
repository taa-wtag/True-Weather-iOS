import Foundation

struct PlaceData: Decodable {
    let countryData: CountryData?

    private enum CodingKeys: String, CodingKey {
        case countryData = "country"
    }
}

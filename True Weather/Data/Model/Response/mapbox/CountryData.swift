import Foundation

struct CountryData: Decodable {
    let countryName: String?
    
    private enum CodingKeys : String, CodingKey {
        case countryName = "name"
    }
}

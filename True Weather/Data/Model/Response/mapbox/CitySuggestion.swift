import Foundation

struct CitySuggestion: Decodable {
    let placeData: PlaceData?
    let cityName: String?
    
    private enum CodingKeys : String, CodingKey {
        case placeData = "context"
        case cityName = "name"
    }
}

import Foundation

struct SearchResponse: Decodable {
    let citySuggestions: [CitySuggestion]?

    private enum CodingKeys: String, CodingKey {
        case citySuggestions = "suggestions"
    }
}

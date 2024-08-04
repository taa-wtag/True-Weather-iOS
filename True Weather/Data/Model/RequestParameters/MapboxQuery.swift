class MapboxQuery: Parameterizable {

    let searchQuery: String?
    let sessionToken: String?
    let language: String?
    let searchLimit: Int?
    let countryName: String?
    let placeTypes: String?
    let apiKey: String?

    init(
        searchQuery: String,
        sessionToken: String? = nil,
        language: String? = nil,
        searchLimit: Int? = nil,
        countryName: String? = nil,
        placeTypes: String? = nil,
        apiKey: String? = nil
    ) {
        self.searchQuery = searchQuery
        self.sessionToken = sessionToken
        self.language = language
        self.searchLimit = searchLimit
        self.countryName = countryName
        self.placeTypes = placeTypes
        self.apiKey = apiKey
    }

    func parameters() -> [String: Any] {
        var parameters = [String: Any]()
        if let query = searchQuery, !query.isEmpty {
            parameters.updateValue(query, forKey: "q")
        } else {
            return parameters
        }
        if let token = sessionToken, !token.isEmpty {
            parameters.updateValue(token, forKey: "session_token")
        } else {
            parameters.updateValue(Constants.Mapbox.SessionToken, forKey: "session_token")
        }
        if let lang = language, !lang.isEmpty {
            parameters.updateValue(lang, forKey: "language")
        }
        if let limit = searchLimit {
            parameters.updateValue(limit, forKey: "limit")
        } else {
            parameters.updateValue(Constants.Mapbox.SearchLimit, forKey: "limit")
        }
        if let country = countryName, !country.isEmpty {
            parameters.updateValue(country, forKey: "country")
        }
        if let types = placeTypes, !types.isEmpty {
            parameters.updateValue(types, forKey: "types")
        } else {
            parameters.updateValue("place", forKey: "types")
        }
        if let key = apiKey, !key.isEmpty {
            parameters.updateValue(key, forKey: "access_token")
        } else {
            parameters.updateValue(APIKeys.mapboxKey, forKey: "access_token")
        }
        return parameters
    }
}

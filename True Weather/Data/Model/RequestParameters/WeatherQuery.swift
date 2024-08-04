class WeatherQuery: Parameterizable {
    let placeName: String?
    let forecastDays: Int?
    let locationCoordinates: (Double, Double)?
    let apiKey: String?

    init(
        placeName: String,
        forecastDays: Int? = -1,
        apiKey: String? = nil
    ) {
        self.placeName = placeName
        self.forecastDays = forecastDays
        self.locationCoordinates = nil
        self.apiKey = apiKey
    }

    init(
        locationCoordinates: (latitude: Double, longitude: Double),
        apiKey: String? = nil
    ) {
        self.placeName = nil
        self.forecastDays = nil
        self.locationCoordinates = locationCoordinates
        self.apiKey = apiKey
    }

    func parameters() -> [String: Any] {
        var parameters = [String: Any]()
        if let query = placeName, !query.isEmpty {
            parameters.updateValue(query, forKey: "q")
        } else if let location = locationCoordinates {
            parameters.updateValue("\(location.0), \(location.1)", forKey: "q")
        } else {
            return parameters
        }
        if let days = forecastDays {
            if days != -1 {
                parameters.updateValue(days, forKey: "days")
            }
        } else {
            parameters.updateValue(Constants.Weather.ForecastMaxDays, forKey: "days")
        }
        if let key = apiKey, !key.isEmpty {
            parameters.updateValue(key, forKey: "key")
        } else {
            parameters.updateValue(APIKeys.weatherKey, forKey: "key")
        }
        return parameters
    }
}

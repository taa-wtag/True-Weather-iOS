//
//  CurrentWeatherResponse.swift
//  True Weather
//
//  Created by Tasnim Ferdous on 7/26/24.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let currentWeatherData: HourlyWeatherData?
    
    private enum CodingKeys : String, CodingKey {
        case currentWeatherData = "current"
    }
}

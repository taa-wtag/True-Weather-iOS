//
//  PlaceResponse.swift
//  True Weather
//
//  Created by Tasnim Ferdous on 7/26/24.
//

import Foundation

struct PlaceResponse: Codable {
    let cities: [CityData]
    
    private enum CodingKeys : String, CodingKey {
        case cities = ""
    }
}

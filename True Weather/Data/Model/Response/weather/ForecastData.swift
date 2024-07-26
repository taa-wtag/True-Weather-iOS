//
//  ForecastData.swift
//  True Weather
//
//  Created by Tasnim Ferdous on 7/26/24.
//

import Foundation

struct ForecastData: Decodable{
    let dailyForecastDataList: [DailyForecastData]?
    
    private enum CodingKeys : String, CodingKey {
        case dailyForecastDataList = "forecastday"
    }
}

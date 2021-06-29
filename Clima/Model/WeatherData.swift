//
//  WeatherData.swift
//  Clima
//
//  Created by Weerawut Chaiyasomboon on 27/10/2562 BE.
//  Copyright © 2562 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

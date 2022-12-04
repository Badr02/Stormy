//
//  WeatherModel.swift
//  Stormy
//
//  Created by Mohamed Adel on 14/11/2022.
//

import Foundation


struct WeatherModel: Codable {
    let name: String
    let dt: Int
    let weather: [WeatherOne]
    let main: MainOne
    let sys: Sys
}

struct WeatherOne: Codable {
    let id: Int
    let main: String
}

struct MainOne: Codable {
    let temp: Double
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}

//
//  ThreeDaysWeatherModel.swift
//  Stormy
//
//  Created by Mohamed Adel on 15/11/2022.
//

import Foundation


struct ThreeDaysWeatherModel: Codable {
    let list: [List]
}

struct List: Codable {
    let dt: Int
    let main: MainTwo
    let weather: [WeatherTwo]
}

struct MainTwo: Codable {
    let temp: Double
}

struct WeatherTwo: Codable {
    let id: Int
}

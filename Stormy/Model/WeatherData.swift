//
//  WeatherData.swift
//  Stormy
//
//  Created by Mohamed Adel on 14/11/2022.
//

import Foundation


struct WeatherData {
    
    var locName: String
    var time: Int
    var sunset: Int
    var sunrise: Int
    var temp: Double
    var conditionID: Int
    var condition: String
    
    var isMorning: Bool {
        if time > sunset || time < sunrise {
            return false
        } else {
            return true
        }
    }
    
    var icon: String {
        switch conditionID {
            case 200...232:
                return "cloud.bolt.fill"
            case 300...321:
                return "cloud.drizzle.fill"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "snowflake"
            case 701...781:
                return "cloud.fog.fill"
            case 800:
                if isMorning {
                    return "sun.max.fill"
                } else {
                    return "moon.fill"
                }
            case 801...804:
                return "cloud.fill"
            default:
                return "cloud.sun.rain.fill"
        }
    }
    
    var backgroundImage: String {
        switch conditionID {
            case 200...232:
                return "thunder"
            case 300...321, 500...531:
                return "rain"
            case 600...622:
                return "snow"
            case 701...781:
                return "fog"
            case 800:
                if isMorning {
                    return "clearDay"
                } else {
                    return "clearNight"
                }
            case 801...804:
                return "cloud"
            default:
                return "clearNight"
        }
    }
   
    
}

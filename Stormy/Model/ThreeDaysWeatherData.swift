//
//  ThreeDaysWeatherData.swift
//  Stormy
//
//  Created by Mohamed Adel on 15/11/2022.
//

import Foundation


struct ThreeDaysWeatherData {
    
    let weatherList: [List]
    var dayOneWeather = (min: Int.max, max: Int.min)
    var dayTwoWeather = (min: Int.max, max: Int.min)
    var dayThreeWeather = (min: Int.max, max: Int.min)
    var days = [String]()
    var conditionDic = ["cloud.bolt.fill": 0, "cloud.drizzle.fill": 0, "cloud.rain.fill": 0, "snowflake": 0, "cloud.fog.fill": 0, "sun.max.fill": 0, "cloud.fill": 0]
    var conditionIcon = [[String:Int]]()
    var threeDaysIcon = [String]()

    
    init(list: [List]) {
        weatherList = list
        let time = TimeInterval(weatherList[0].dt)
        let dayOne = Calendar.current.date(byAdding: .day, value: 1, to: Date(timeIntervalSince1970: time))
        let dayTwo = Calendar.current.date(byAdding: .day, value: 2, to: Date(timeIntervalSince1970: time))
        let dayThree = Calendar.current.date(byAdding: .day, value: 3, to: Date(timeIntervalSince1970: time))
        guard let dayOne = dayOne, let dayTwo = dayTwo, let dayThree = dayThree else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        days.append(dateFormatter.string(from: dayOne))
        days.append(dateFormatter.string(from: dayTwo))
        days.append(dateFormatter.string(from: dayThree))
        conditionIcon.append(conditionDic)
        conditionIcon.append(conditionDic)
        conditionIcon.append(conditionDic)
        for day in weatherList {
            let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
            let temp = Int(round(day.main.temp))
            let condition = getCondidtion(conditionID: day.weather[0].id)
            if Calendar.current.isDate(dayOne, equalTo: date, toGranularity: .day) {
                if dayOneWeather.min > temp {
                    dayOneWeather.min = temp
                }
                if dayOneWeather.max < temp {
                    dayOneWeather.max = temp
                }
                if let num = conditionIcon[0][condition] {
                    conditionIcon[0][condition] = num + 1
                }
            } else if Calendar.current.isDate(dayTwo, equalTo: date, toGranularity: .day) {
                if dayTwoWeather.min > temp {
                    dayTwoWeather.min = temp
                }
                if dayTwoWeather.max < temp {
                    dayTwoWeather.max = temp
                }
                if let num = conditionIcon[1][condition] {
                    conditionIcon[1][condition] = num + 1
                }
            } else if Calendar.current.isDate(dayThree, equalTo: date, toGranularity: .day) {
                if dayThreeWeather.min > temp {
                    dayThreeWeather.min = temp
                }
                if dayThreeWeather.max < temp {
                    dayThreeWeather.max = temp
                }
                if let num = conditionIcon[2][condition] {
                    conditionIcon[2][condition] = num + 1
                }
            }
        }
        
        getIcon()
    }
    
    
    func getCondidtion(conditionID: Int) -> String {
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
                return "sun.max.fill"
            case 801...804:
                return "cloud.fill"
            default:
                return "cloud.sun.rain.fill"
        }
    }
    
    mutating func getIcon() {
        
        for dic in conditionIcon {
            var max = 0
            var result = ""
            for (key, value) in dic {
                if value > max {
                    max = value
                    result = key
                }
            }
            threeDaysIcon.append(result)
        }
        
    }
    
}


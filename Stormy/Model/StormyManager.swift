//
//  StormyBrain.swift
//  Stormy
//
//  Created by Mohamed Adel on 14/11/2022.
//

import Foundation
import CoreLocation
import Network

protocol WeatherChangeDelegate {
    func didChangeWeather(weatherData: WeatherData)
    func didFiveDaysChange(threeDays: ThreeDaysWeatherData)
    func invalidCityName()
}

class StormyManager {
    
    var internetIsContected = false
    let monitor = NWPathMonitor()
    let secrets = Secrets()    
    var delegate: WeatherChangeDelegate?
    var functionShouldStop = false
    
    func urlByCoordinates(location: CLLocation) {
        let location = location.coordinate
        guard let CurrentWeatherurl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(secrets.apiKey)&units=metric") else { return }
        
        guard let threeDaysUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(secrets.apiKey)&units=metric") else { return }
        
        if functionShouldStop {
            return
        }
        
        performReqest(url: CurrentWeatherurl)
        performThreeDaysReqest(url: threeDaysUrl)
        
    }
    
    func urlByCityName(cityName: String) {

        guard let CurrentWeatherurl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(secrets.apiKey)&units=metric") else {
            delegate?.invalidCityName()
            return
        }
        
        guard let threeDaysUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(secrets.apiKey)&units=metric") else { return }
        
        
        performReqest(url: CurrentWeatherurl)
        performThreeDaysReqest(url: threeDaysUrl)
    }
    
    func performReqest(url: URL) {

        
        let task = URLSession.shared.dataTask(with: url){ data , response , error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(WeatherModel.self, from: data){
                let temp = round(data.main.temp)
                let locName = data.name
                let time = data.dt
                let sunset = data.sys.sunset
                let sunrise = data.sys.sunrise
                let conditionID = data.weather[0].id
                let condition = data.weather[0].main
                let weatherData = WeatherData(locName: locName, time: time, sunset: sunset, sunrise: sunrise, temp: temp, conditionID: conditionID, condition: condition)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didChangeWeather(weatherData: weatherData)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.invalidCityName()
                }
            }
        }
        task.resume()
        
    }
    
    
    func performThreeDaysReqest(url: URL) {
        
        let task = URLSession.shared.dataTask(with: url){ data , response , error in

            guard let data = data else { return }
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(ThreeDaysWeatherModel.self, from: data){
                let list = data.list
                let threeDaysWeatherData = ThreeDaysWeatherData(list: list)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFiveDaysChange(threeDays: threeDaysWeatherData)
                }
            }
        }
        task.resume()
        
    }
    
    func checkInternet() {
       monitor.pathUpdateHandler = { [weak self] path in
           if path.status == .satisfied {
               self?.internetIsContected = true
           } else {
               self?.internetIsContected = false
           }
       }
       
       let queue = DispatchQueue(label: "InternetConnection")
       monitor.start(queue: queue)
        
   }
    

    
}

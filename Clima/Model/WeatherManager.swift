//
//  WeatherManager.swift
//  Clima
//

import Foundation
import CoreLocation

struct WeatherManager {
   
    
    var urlForCity: (String) -> String =  { city in
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR_API_KEY&units=metric"
        let urlString = "\(weatherURL)&q=\(city)"
        return urlString
    }
    
    var urlForLatLong: (CLLocation) -> String = { location in
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR_API_KEY&units=metric"
        return "\(weatherURL)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
    }
    
    
    
    func getWeather(url: String, onCompletion: @escaping (String, String, String) -> Void) {
        let url = URL(string: url)
        let urlSession = URLSession(configuration: .default)
         
        
        let task = urlSession.dataTask(with: url!) { data,response, error in
            if error != nil {
                print(error)
            }
            
            if let safedata = data {
                            let decoder = JSONDecoder()
                           let weather = try! decoder.decode(WeatherModel.self, from: safedata) // cpu intensive
                            let conditionId = weather.weather.first?.id ?? 800
                            let temp = weather.main.temp
                            let name = weather.name
                            let weatherBrain = WeatherBrain(conditionId: conditionId, citysName: name, temp: temp)
                onCompletion(weatherBrain.conditionName, weatherBrain.tempString,weatherBrain.citysName )
            }
        }
        task.resume()
        
    }
}

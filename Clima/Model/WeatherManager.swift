//
//  WeatherManager.swift
//  Clima
//
//  Created by Weerawut Chaiyasomboon on 25/10/2562 BE.
//  Copyright © 2562 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=YOUR_APPID&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: Double, longtitude: Double){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1.Create URL
        guard let url = URL(string: urlString) else {return}
        //2.Create URLSession
        let session = URLSession(configuration: .default)
        //3.Give the session a task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
               return
            }
            guard let safeData = data else {return}
            guard let weather = self.parseJSON(safeData) else {return}
            self.delegate?.didUpdateWeather(self, weather: weather)
        }
        //4.Start a task
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeerData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodeerData.name
            let temp = decodeerData.main.temp
            let conditionID = decodeerData.weather[0].id
            
            let weather = WeatherModel(cityName: name, temperature: temp, conditionID: conditionID)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}

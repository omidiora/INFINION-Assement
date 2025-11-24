// WeatherDetailViewModel.swift

import Foundation

class WeatherDetailViewModel {
    private let weatherResponse: WeatherResponse
    
    init(weatherResponse: WeatherResponse) {
        self.weatherResponse = weatherResponse
    }
    
    var cityName: String {
        return weatherResponse.name
    }
    
    var temperature: String {
        return String(format: "%.1f°C", weatherResponse.main.temp)
    }
    
    var description: String {
        return weatherResponse.weather.first?.description.capitalized ?? "N/A"
    }
}

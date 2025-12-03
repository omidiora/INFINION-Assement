//
//  WeatherService.swift
//  WeatherAssessment
//

import Foundation

final class WeatherService: WeatherServiceProtocol {
    private let apiKey = "bc25b084a72f4dbe3d2b403a8e69e4b2" 
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard var url = URL(string: baseURL) else { throw URLError(.badURL) }
        url.append(queryItems: [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ])
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}

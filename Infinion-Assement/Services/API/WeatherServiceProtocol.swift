//
//  WeatherServiceProtocol.swift
//  WeatherAssessment
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
}

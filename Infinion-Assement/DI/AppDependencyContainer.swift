//
//  AppDependencyContainer.swift
//  WeatherAssessment
//

import Foundation

final class AppDependencyContainer: ObservableObject {
    lazy var weatherService: WeatherServiceProtocol = WeatherService()
    lazy var favoriteCityManager = FavoriteCityManager()
}

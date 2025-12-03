// ViewModels/HomeViewModel.swift

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var weather: WeatherResponse?
    @Published var favoriteWeather: WeatherResponse?
    @Published var isLoading = false
    @Published var error: String?
    @Published var navigate = false
    
    // MARK: - Favorite City
    var favoriteCity: String {
        favoriteCityManager.get()
    }
    
    var favoriteIcon: String {
        guard let desc = favoriteWeather?.weather.first?.description.lowercased() else {
            return "cloud"
        }
        if desc.contains("clear") { return "sun.max.fill" }
        if desc.contains("cloud") { return "cloud.fill" }
        if desc.contains("rain") || desc.contains("drizzle") { return "cloud.rain.fill" }
        if desc.contains("snow") { return "cloud.snow.fill" }
        if desc.contains("thunder") { return "cloud.bolt.fill" }
        return "cloud.sun.fill"
    }
    
    
    var searchHistory: [String] {
        searchHistoryManager.history
    }
    
  
    private let weatherService: WeatherServiceProtocol
    private let favoriteCityManager: FavoriteCityManager
    private let searchHistoryManager: SearchHistoryManager
    
    init(
        weatherService: WeatherServiceProtocol,
        favoriteCityManager: FavoriteCityManager,
        searchHistoryManager: SearchHistoryManager = .shared
    ) {
        self.weatherService = weatherService
        self.favoriteCityManager = favoriteCityManager
        self.searchHistoryManager = searchHistoryManager
    }
    
    // MARK: - Load Favorite City
    func loadFavorite() {
        let fav = favoriteCityManager.get()
        if !fav.isEmpty && cityName.isEmpty {
            cityName = fav
        }
    }
    
    // MARK: - Load Weather for Favorite City
    func loadFavoriteWeather() {
        let fav = favoriteCityManager.get()
        guard !fav.isEmpty else { return }
        
        Task {
            do {
                let result = try await weatherService.fetchWeather(for: fav)
                favoriteWeather = result
            } catch {
                print("Could not load favorite weather: \(error)")
            }
        }
    }
    
    // MARK: - Search City
    func search() {
        let city = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            error = "Please enter a city name"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let result = try await weatherService.fetchWeather(for: city)
                weather = result
                
                // Save to search history (latest first)
                searchHistoryManager.add(result.name)
                
                navigate = true
            } catch {
                self.error = "City not found. Please check spelling."
            }
            isLoading = false
        }
    }
}

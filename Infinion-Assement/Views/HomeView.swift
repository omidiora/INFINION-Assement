// Views/HomeView.swift

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var container: AppDependencyContainer
    @StateObject private var viewModel = HomeViewModel(
        weatherService: AppDependencyContainer().weatherService,
        favoriteCityManager: AppDependencyContainer().favoriteCityManager,
        searchHistoryManager: SearchHistoryManager.shared
    )
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Favorite City (Top)
                if !viewModel.favoriteCity.isEmpty {
                    Section {
                        Button(action: {
                            viewModel.cityName = viewModel.favoriteCity
                            viewModel.search()
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(viewModel.favoriteCity)
                                        .font(.title3.bold())
                                    if let temp = viewModel.favoriteWeather?.main.temp {
                                        Text("\(Int(temp))°C • Tap to refresh")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: viewModel.favoriteIcon)
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                            }
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    } header: {
                        Text("Favorite City")
                    }
                }
                
                // MARK: - Search Section
                Section {
                    TextField("Search city...", text: $viewModel.cityName)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit { viewModel.search() }
                    
                    Button("Search Weather") {
                        viewModel.search()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.isLoading || viewModel.cityName.trimmingCharacters(in: .whitespaces).isEmpty)
                    
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                            Text("Loading weather...")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // MARK: - Search History (Under Search Button!)
                if !viewModel.searchHistory.isEmpty {
                    Section("Recent Searches") {
                        ForEach(viewModel.searchHistory, id: \.self) { city in
                            Button(action: {
                                viewModel.cityName = city
                                viewModel.search()
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.secondary)
                                    Text(city)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Weather")
            .navigationDestination(isPresented: $viewModel.navigate) {
                if let data = viewModel.weather {
                    WeatherDetailView(weather: data)
                }
            }
            .onAppear {
                viewModel.loadFavorite()
                viewModel.loadFavoriteWeather()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppDependencyContainer())
}

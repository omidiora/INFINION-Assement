// Services/Storage/FavoriteCityManager.swift

import Foundation
import SwiftUI

final class FavoriteCityManager: ObservableObject {
    @AppStorage("favoriteCity") var city: String = ""
    
    func save(_ city: String) {
        self.city = city.trimmingCharacters(in: .whitespaces)
    }
    
    func get() -> String { city }
    func clear() { city = "" }
}

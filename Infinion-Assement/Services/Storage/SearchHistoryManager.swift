// Services/Storage/SearchHistoryManager.swift

import Foundation

final class SearchHistoryManager {
    static let shared = SearchHistoryManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "searchHistory"
    
    private init() {}
    
    var history: [String] {
        get {
            if let data = userDefaults.data(forKey: key),
               let array = try? JSONDecoder().decode([String].self, from: data) {
                return array.reversed() // newest first
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue.reversed()) {
                userDefaults.set(data, forKey: key)
            }
        }
    }
    
    func add(_ city: String) {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        var current = history
        current.removeAll { $0.lowercased() == trimmed.lowercased() } // remove duplicate
        current.append(trimmed)
        
        if current.count > 10 {
            current.removeFirst()
        }
        
        history = current
    }
    
    func clear() {
        userDefaults.removeObject(forKey: key)
    }
}

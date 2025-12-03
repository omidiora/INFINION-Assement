//
//  ContentView.swift
//  Infinion-Assement
//
//  Created by Omidiora on 03/12/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var container = AppDependencyContainer()
    var body: some View {
        SplashView()
            .environmentObject(container)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppDependencyContainer())
}

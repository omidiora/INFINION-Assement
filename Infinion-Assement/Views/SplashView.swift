//
//  SplashView.swift
//  WeatherAssessment
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var container: AppDependencyContainer
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                HomeView()
                    .environmentObject(container)
            } else {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 90))
                            .foregroundColor(.white)
                        Text("Weather App by omidiora emmanuel")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isActive = true }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppDependencyContainer())
}

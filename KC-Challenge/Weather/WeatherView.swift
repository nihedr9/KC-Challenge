//
//  ContentView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import SwiftUI
import ComposableArchitecture

@MainActor
struct WeatherView: View {
  
  @Bindable var store: StoreOf<Weather>
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    VStack(spacing: 24) {
      VStack {
        switch store.response {
        case .success(let weather):
          weatherView(for: weather)
        case .failure:
          openSettingsView
        }
      }
      
      Button("Show Stories") {
        store.send(.showStories)
      }
    }
    .padding()
    .popover(item: $store.scope(state: \.destination?.popover, action: \.destination.popover)) { store in
      StoryView(store: store)
    }
    .onAppear {
      store.send(.checkLocationPermission)
    }
  }
  
  private func weatherView(for weather: WeatherModel) -> some View {
    VStack(spacing: 8) {
      
      AsyncImage(url: weather.iconURL) { image in
        image
          .resizable()
      } placeholder: {
        Image(systemName: "cloud.rainbow.crop")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }
      .scaledToFit()
      .frame(width: 80)
      
      VStack(spacing: 4) {
        Text(weather.cityName)
          .font(.headline.weight(.bold))
        Text(weather.description.capitalized)
          .font(.subheadline.weight(.semibold))
        HStack {
          Text("\(weather.temperature)")
            .font(.subheadline.weight(.semibold))
          Text("(feels like: \(weather.feelsLike))")
        }
        Text("Min: \(weather.min)  Max: \(weather.max)")
          .font(.subheadline.weight(.semibold))
      }
      
      Button("Fetch Weather") {
        store.send(.fetchUserLocation)
      }
    }
  }
  
  private var openSettingsView: some View {
    VStack {
      ContentUnavailableView("Please enable location service",
                             systemImage: "location.slash.fill")
      Button("open Settings") {
        store.send(.openSettings)
      }
    }
  }
}

#Preview {
  WeatherView(
    store: .init(
      initialState: Weather.State(),
      reducer: {
        Weather()
      })
  )
}

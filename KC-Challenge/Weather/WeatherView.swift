//
//  ContentView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import SwiftUI
import ComposableArchitecture

struct WeatherView: View {
  
  @Bindable var store: StoreOf<Weather>
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    VStack(spacing: 24) {
      VStack {
        switch store.response {
        case .success(let weather):
          weatherView(for: weather)
            .redacted(reason: store.isRequestInFlight ? .placeholder : [])
        case .failure(let error):
          errorView(error)
        }
      }
      
      Button("Show Stories") {
        store.send(.showStories)
      }
    }
    .padding()
    .popover(item: $store.scope(state: \.destination?.popover, action: \.destination.popover)) { store in
      StoriesView(store: store)
    }
    .onAppear {
      store.send(.checkLocationPermission)
    }
    .onChange(of: scenePhase) { _, newPhase in
      switch newPhase {
      case .active:
        store.send(.checkLocationPermission)
      default:
        break
      }
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
      
      if store.isRequestInFlight {
        ProgressView()
        Text("Fetching weather...")
          .font(.subheadline.weight(.semibold))
          .unredacted()
      } else {
        Button("Fetch Weather") {
          store.send(.fetchWeatherTapped)
        }
      }
    }
  }
  
  private func errorView(_ error: WeatherError) -> some View {
    VStack {
      ContentUnavailableView {
        VStack {
          Image(systemName: error.sysImageName)
          Text(error.title)
        }
      } description: {
        Text(error.description)
      } actions: {
        errorActionView(error)
      }
    }
  }
  
  @ViewBuilder
  private func errorActionView(_ error: WeatherError) -> some View {
    switch error {
    case .locationPermissionDenied,
        .locationPermissionIsDisabled,
        .cannotFetchLocation:
      Button("Open Settings") {
        store.send(.openSettings)
      }
    case .cannotFetchWeather:
      Button("retry") {
        store.send(.fetchWeatherTapped)
      }
    case .locationPermissionNotDetermined:
      Button("Request Location Permission") {
        store.send(.askForLocationPermission)
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

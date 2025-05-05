//
//  Dependencies.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 02/05/2025.
//

import WeatherService
import CoreLocation
import ComposableArchitecture
import LocationService
import UIKit

// MARK: - Weather Client

@DependencyClient
struct WeatherClient {
  var fetchWeather: (CLLocation) async throws -> WeatherResponse
}

extension WeatherClient: DependencyKey {
  static let liveValue = Self { location in
    let weatherService = WeatherService(apiKey: "206d22d633659084c00b2795ff733e83")
    return try await weatherService.getWeather(
      lat: location.coordinate.latitude,
      long: location.coordinate.longitude,
      units: "metric",
      lang: "fr"
    )
  }
}

extension WeatherClient: TestDependencyKey {
  static let previewValue = Self { _ in .mock }
  
  static let testValue = Self()
}

// MARK: - Location Client

@DependencyClient
struct UserLocationClient {
  var isEnabled: @Sendable () async throws -> Bool
  var authorizedStatus:  @Sendable () async throws -> CLAuthorizationStatus
  var getUserLocation: @Sendable () async throws -> CLLocation
  var requestPermission: @Sendable () async throws -> Void
}

extension UserLocationClient: DependencyKey {
  static let liveValue = Self {
    await LocationService().isEnabled
  } authorizedStatus: {
    await LocationService().authorizationStatus
  } getUserLocation: {
    try await LocationService().getUserLocation()
  } requestPermission: {
    try await LocationService().requestPermission()
  }
}

extension UserLocationClient: TestDependencyKey {
  
  static let parisCoordinates = CLLocation(
    latitude: 48.8575,
    longitude: 2.3514
  )
  
  static let previewValue = Self {
    true
  } authorizedStatus: {
    .notDetermined
  } getUserLocation: {
    parisCoordinates
  } requestPermission: {}
  
  static let testValue = Self()
}

// MARK: - Settings

enum OpenSettingsKey: DependencyKey {
  static let liveValue: @Sendable () async -> Void = {
    await MainActor.run {
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
  }
}

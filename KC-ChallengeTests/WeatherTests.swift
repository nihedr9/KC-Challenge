//
//  WeatherTest.swift
//  KC-ChallengeTests
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import ComposableArchitecture
import CoreLocation
import Testing

@testable import KC_Challenge

@MainActor
struct WeatherTests {
  
  @Test
  func checkNotEnabledPermission() async throws {
    let store = TestStore(initialState: Weather.State()) {
      Weather()
    } withDependencies: {
      $0.userLocationClient.isEnabled = { false }
    }
    store.exhaustivity = .off

    await store.send(.checkLocationPermission)
    
    await store.receive(\.setError) {
      $0.response = .failure(.locationPermissionIsDisabled)
    }
  }
  
  @Test
  func checkPermissionError() async throws {
    let store = TestStore(initialState: Weather.State()) {
      Weather()
    } withDependencies: {
      $0.userLocationClient.authorizedStatus = { .notDetermined }
    }
    store.exhaustivity = .off

    await store.send(.checkLocationPermission)
    
    await store.receive(\.setError) {
      $0.response = .failure(.locationPermissionNotDetermined)
    }
  }
  
  @Test
  func fetchWeather() async throws {
    let store = TestStore(initialState: Weather.State()) {
      Weather()
    }
    
    store.exhaustivity = .off
    
    await store.send(.fetchWeather(.init())) {
      $0.response = .success(.placeholder)
    }
    
    await store.receive(\.setResponse) {
      $0.isRequestInFlight = false
      $0.response = .success(.mock)
    }
  }
}

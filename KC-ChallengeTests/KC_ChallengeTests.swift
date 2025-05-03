//
//  KC_ChallengeTests.swift
//  KC-ChallengeTests
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import Testing
@testable import KC_Challenge
import ComposableArchitecture
import CoreLocation

struct KC_ChallengeTests {
  
  @Test(arguments: [CLLocation(latitude: 0, longitude: 0)])
  func fetchLocation(location: CLLocation) async throws {
    let store = await TestStore(initialState: Weather.State()) {
      Weather()
    }
    store.exhaustivity = false
    
    await store.send(.fetchWeather(location)) {
      $0.response = .success(
        WeatherModel(
          id: "id",
          cityName: "cityName",
          temperature: "18",
          iconURL: nil
        )
      )
    }
    
    await store.finish(timeout: 10)
//    await store.receive(\Weather.State.response) {
//      $0.response = .success(
//        .init(
//          id: "id",
//          cityName: "cityName",
//          temperature: "18",
//          iconURL: nil
//        )
//      )
//    }

    
  }
}

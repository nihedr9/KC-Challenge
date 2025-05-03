//
//  KC_ChallengeApp.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct KC_ChallengeApp: App {
  
  static let store = StoreOf<Weather>(
    initialState: Weather.State(),
    reducer: { Weather() }
  )
  
  var body: some Scene {
    WindowGroup {
      WeatherView(store: Self.store)
    }
  }
}

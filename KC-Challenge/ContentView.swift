//
//  ContentView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 28/04/2025.
//

import SwiftUI
import LocationService
import WeatherClient

struct ContentView: View {
  
  let locationService = LocationService()
  let client = WeatherClient(apiKey: "206d22d633659084c00b2795ff733e83")

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
          guard let location = try? await locationService.getLocation() else {
            return
          }
          let response = try! await client.getWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude)
          print(response)
        }
    }
}

#Preview {
    ContentView()
}

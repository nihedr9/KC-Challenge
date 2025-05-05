//
//  WeatherModel.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation
import WeatherService

struct WeatherModel: Identifiable, Hashable, Equatable {
  let id: String
  let cityName: String
  let description: String
  let temperature: String
  let feelsLike: String
  let min: String
  let max: String
  let iconURL: URL?
}

extension WeatherModel {
  
  init(from response: WeatherResponse) {
    self.id = "\(response.id)"
    self.cityName = response.name
    self.description = response.weather.first?.description ?? ""
    self.temperature = "\(Int(response.main.temp.rounded(.up)))°C"
    self.feelsLike = "\(Int(response.main.feelsLike.rounded(.up)))°C"
    self.min = "\(Int(response.main.tempMin.rounded(.up)))°C"
    self.max = "\(Int(response.main.tempMax.rounded(.up)))°C"
    self.iconURL = response.iconURL
  }
}


extension WeatherModel {
  static let placeholder = WeatherModel(
    id: "id",
    cityName: "--",
    description: "",
    temperature: "--°C",
    feelsLike: "--°C",
    min: "--°C",
    max: "--°C",
    iconURL: nil
  )
}

extension WeatherModel {
  static let mock = WeatherModel(from: .mock)
}

extension WeatherResponse {
  static let mock = WeatherResponse(
    id: 0,
    main: .init(feelsLike: 17, temp: 18, tempMax: 20, tempMin: 10),
    name: "Paris",
    weather: [.init(description: "ciel dégagé", icon: "01d", id: 0, main: "")]
  )
}

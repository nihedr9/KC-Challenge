//
//  WeatherModel.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

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

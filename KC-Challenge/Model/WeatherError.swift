//
//  WeatherError.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

enum WeatherError: Error {
  case locationPermissionIsDisabled
  case locationPermissionNotDetermined
  case locationPermissionDenied
  case cannotFetchLocation
  case cannotFetchWeather
  
  var title: String {
    switch self {
    case .locationPermissionIsDisabled:
      return "Location Permission Disabled"
    case .locationPermissionNotDetermined:
      return "Location Permission Not Determined"
    case .locationPermissionDenied:
      return "Location Permission Denied"
    case .cannotFetchLocation:
      return "Cannot Fetch Location"
    case .cannotFetchWeather:
      return "Cannot Fetch Weather"
    }
  }
  
  var description: String {
    switch self {
    case .locationPermissionIsDisabled,
        .locationPermissionNotDetermined,
        .locationPermissionDenied:
      return "Please enable it in settings."
    case .cannotFetchLocation:
      return "Please check your location settings."
    case .cannotFetchWeather:
      return "Please try again later."
    }
  }
}

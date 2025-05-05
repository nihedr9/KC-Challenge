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
      "Location Permission Disabled"
    case .locationPermissionNotDetermined:
      "Location Permission Not Determined"
    case .locationPermissionDenied:
      "Location Permission Denied"
    case .cannotFetchLocation:
      "Cannot Fetch Location"
    case .cannotFetchWeather:
      "Cannot Fetch Weather"
    }
  }
  
  var description: String {
    switch self {
    case .locationPermissionIsDisabled,
        .locationPermissionDenied:
      "Please enable it in settings."
    case .locationPermissionNotDetermined:
      ""
    case .cannotFetchLocation:
      "Please check your location settings."
    case .cannotFetchWeather:
      "Please try again later."
    }
  }
  
  var sysImageName: String {
    switch self {
    case .cannotFetchWeather:
      "icloud.slash"
    default:
      "location.slash.fill"
    }
  }
}

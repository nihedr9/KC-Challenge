//
//  Weather.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 01/05/2025.
//

import ComposableArchitecture
import CoreLocation
import LocationService
import WeatherService

@Reducer
struct Weather{
  
  @Reducer(state: .equatable)
  enum Destination {
    case popover(Stories)
  }
  
  @ObservableState
  struct State: Equatable {
    @Presents var destination: Destination.State?
    var response: Result<WeatherModel, WeatherError> = .success(
      .init(
        id: "id",
        cityName: "--",
        description: "",
        temperature: "--°C",
        feelsLike: "--°C",
        min: "--°C",
        max: "--°C",
        iconURL: nil
      )
    )
  }
  
  enum Action {
    case checkLocationPermission
    case fetchUserLocation
    case fetchWeather(CLLocation)
    case updateResponse(WeatherModel)
    case setError(WeatherError)
    case openSettings
    case destination(PresentationAction<Destination.Action>)
    case showStories
  }
  
  @Dependency(UserLocationClient.self) var userLocationClient
  @Dependency(WeatherClient.self) var weatherClient
  @Dependency(OpenSettingsKey.self) var openSettings
  
  var body: some Reducer<State, Action> {
    Reduce {
      state,
      action in
      switch action {
      case .checkLocationPermission:
        return .run { send in
          do {
            let status = try await userLocationClient.requestPermission()
            if status.isAuthorized {
              await send(.fetchUserLocation)
            } else {
              await send(.setError(.locationPermissionDenied))
            }
          } catch {
            await send(.setError(.locationPermissionDenied))
          }
        }
      case .fetchUserLocation:
        return .run { send in
          do {
            let userLocation = try await userLocationClient.getUserLocation()
            await send(.fetchWeather(userLocation))
          } catch {
            await send(.setError(.cannotFetchLocation))
          }
        }
        
      case .fetchWeather(let location):
        return .run { send in
          do {
            let response = try await weatherClient.fetchWeather(location)
            await send(.updateResponse(.init(from: response)))
          } catch {
            await send(.setError(.cannotFetchWeather))
          }
        }
        
      case .updateResponse(let model):
        state.response = .success(model)
        return .none
        
      case .setError(let error):
        state.response = .failure(error)
        return .none
        
      case .openSettings:
        return .run { _ in await openSettings() }
      case .showStories:
        state.destination = .popover(Stories.State())
        return .none
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

enum WeatherError: Error {
  case locationPermissionDenied
  case cannotFetchLocation
  case cannotFetchWeather
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

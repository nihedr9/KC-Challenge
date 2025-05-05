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
    var isRequestInFlight = false
    var response: Result<WeatherModel, WeatherError> = .success(.placeholder)
  }
  
  enum Action {
    case askForLocationPermission
    case checkLocationPermission
    case fetchWeatherTapped
    case setRequestInFlight(Bool)
    case fetchWeather(CLLocation)
    case setResponse(WeatherModel)
    case setError(WeatherError)
    case openSettings
    case destination(PresentationAction<Destination.Action>)
    case showStories
  }
  
  @Dependency(\.userLocationClient) var userLocationClient
  @Dependency(\.weatherClient) var weatherClient
  @Dependency(OpenSettingsKey.self) var openSettings
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .askForLocationPermission:
        return .run { send in
            try await userLocationClient.requestPermission()
        } catch: { _, send in
          await send(.setError(.cannotFetchLocation))
        }
        
      case .checkLocationPermission:
        return .run { send in
          let isEnabled = try await userLocationClient.isEnabled()
          guard isEnabled else {
            await send(.setError(.locationPermissionIsDisabled))
            return
          }
          let status = try await userLocationClient.authorizedStatus()
          if status.isNotDetermined {
            await send(.setError(.locationPermissionNotDetermined))
          } else if status.isDenied {
            await send(.setError(.locationPermissionDenied))
          } else if status.isAuthorized {
            await send(.fetchWeatherTapped)
          }
        } catch: { _, send in
          await send(.setError(.locationPermissionDenied))
        }
        
      case .fetchWeatherTapped:
        return .run { send in
          await send(.setResponse(.placeholder))
          await send(.setRequestInFlight(true))
          let userLocation = try await userLocationClient.getUserLocation()
          await send(.fetchWeather(userLocation))
        }
        
      case .fetchWeather(let location):
        return .run { send in
          let response = try await weatherClient.fetchWeather(location)
          await send(.setResponse(.init(from: response)))
        } catch: { _, send in
          await send(.setError(.cannotFetchWeather))
        }
        
      case .setResponse(let model):
        state.response = .success(model)
        state.isRequestInFlight = false
        return .none
        
      case .setError(let error):
        state.response = .failure(error)
        state.isRequestInFlight = false
        return .none
        
      case .openSettings:
        return .run { _ in await openSettings() }
        
      case .showStories:
        state.destination = .popover(Stories.State())
        return .none
        
      case .destination:
        return .none
        
      case .setRequestInFlight(let isRequestInFlight):
        state.isRequestInFlight = isRequestInFlight
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

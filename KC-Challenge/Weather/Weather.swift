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
    var response: Result<WeatherModel, WeatherError> = .success(.plcaeholder)
  }
  
  enum Action {
    case askForLocationPermission
    case checkLocationPermission
    case fetchUserLocation
    case setRequestInFlight(Bool)
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
    Reduce { state, action in
      switch action {
        
      case .askForLocationPermission:
        return .run { send in
          do {
            try await userLocationClient.requestPermission()
          } catch {
            await send(.setError(.cannotFetchLocation))
          }
        }
        
      case .checkLocationPermission:
        return .run { send in
          do {
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
              await send(.fetchUserLocation)
            }
          } catch {
            await send(.setError(.locationPermissionDenied))
          }
        }
        
      case .fetchUserLocation:
        return .run { send in
          do {
            await send(.updateResponse(.plcaeholder))
            await send(.setRequestInFlight(true))
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

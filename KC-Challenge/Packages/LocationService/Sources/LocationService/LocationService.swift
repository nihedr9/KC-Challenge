
import CoreLocation
import SwiftLocation

protocol LocationServiceProtocol {
  var isEnabled: Bool { get async }
  func getUserLocation() async throws -> CLLocation
  func requestPermission() async throws -> CLAuthorizationStatus
}

@MainActor
public struct LocationService: LocationServiceProtocol {
  
  internal let manager = Location()
  
  public init() { }
  
  internal var isEnabled: Bool {
    get async {
      await manager.locationServicesEnabled
    }
  }
  
  public func getUserLocation() async throws -> CLLocation {
    let manager = Location()
    let location = try await manager.requestLocation().location
    guard let location else {
      throw LocationErrors.locationNotFound
    }
    return location
  }
  
  public func requestPermission() async throws -> CLAuthorizationStatus {
    guard await isEnabled else {
      throw LocationErrors.locationServicesDisabled
    }
    do {
      return try await manager.requestPermission(.whenInUse)
    } catch {
      throw LocationErrors.authorizationRequired
    }
  }
}

extension Location: @unchecked @retroactive Sendable { }
extension Tasks.ContinuousUpdateLocation.StreamEvent: @unchecked @retroactive Sendable { }

enum LocationErrors: Error {
  case locationServicesDisabled
  case authorizationRequired
  case locationNotFound
}

extension CLAuthorizationStatus {
  
  public var isAuthorized: Bool {
    switch self {
    case .authorizedAlways, .authorizedWhenInUse:
      return true
    default:
      return false
    }
  }
}

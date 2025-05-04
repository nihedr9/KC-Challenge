
import CoreLocation
import SwiftLocation

protocol LocationServiceProtocol {
  var isEnabled: Bool { get async }
  var authorizationStatus: CLAuthorizationStatus { get async }
  func getUserLocation() async throws -> CLLocation
  func requestPermission() async throws -> CLAuthorizationStatus
}

@MainActor
public struct LocationService: LocationServiceProtocol {
  
  internal let manager = Location()
  
  public init() { }
  
  public var isEnabled: Bool {
    get async {
      await manager.locationServicesEnabled
    }
  }
  
  public var authorizationStatus: CLAuthorizationStatus {
    get async {
      await MainActor.run {
        manager.authorizationStatus
      }
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
  
  @discardableResult
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
  
  public var isDenied: Bool {
    switch self {
    case .denied, .restricted:
      return true
    default:
      return false
    }
  }
  
  public var isNotDetermined: Bool {
    switch self {
    case .notDetermined:
      return true
    default:
      return false
    }
  }
}

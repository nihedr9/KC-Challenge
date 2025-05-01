
import SwiftLocation
import CoreLocation

public struct LocationService {
  
  internal let manager = Location()
  
  public init() { }
  
  public func getLocation() async throws -> CLLocation? {
    if manager.authorizationStatus == .notDetermined {
      try await requestPermission()
    }
    return try await manager.requestLocation().location
  }
  
  public func requestPermission() async throws {
    try await manager.requestPermission(.whenInUse)
  }
}


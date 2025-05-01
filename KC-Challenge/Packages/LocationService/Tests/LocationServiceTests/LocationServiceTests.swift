import Testing
@testable import LocationService


struct LocationServiceTests {
 
  @Test
  func getLocation() async throws {
    let locationService = LocationService()
    let location = try await locationService.getLocation()
    #expect(location != nil)
    #expect(location?.coordinate.latitude != 0)
    #expect(location?.coordinate.longitude != 0)
  }
}


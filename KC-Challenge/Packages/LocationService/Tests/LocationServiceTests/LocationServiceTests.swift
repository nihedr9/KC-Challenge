import Testing
@testable import LocationService


struct LocationServiceTests {
 
  @Test
  func getLocation() async throws {
    let locationService = mockedLocationService()
    let location = try await locationService.getUserLocation()
    #expect(location.coordinate.latitude != 0)
    #expect(location.coordinate.longitude != 0)
  }
}


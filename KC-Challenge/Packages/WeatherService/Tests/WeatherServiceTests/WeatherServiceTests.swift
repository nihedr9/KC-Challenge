import Testing
@testable import WeatherService

struct WeatherServiceTests {
  
  let client = WeatherService(apiKey: "bcfd8daab09ad5320c7f92ff23072c36")
  
  @Test(
    "fetch `Paris` weather by lat and long coordinates",
    arguments: [(48.8575, 2.3514, "fr", "metric")]
  )
  func getWeather(
    lat: Double,
    long: Double,
    units: String?,
    lang: String?
  ) async throws {
    let response = try await client.getWeather(
      lat: lat,
      long: long,
      units: units,
      lang: lang
    )
    #expect(response.name == "Paris")
    #expect(response.coord?.lat == lat)
    #expect(response.coord?.lon == long)
  }
}

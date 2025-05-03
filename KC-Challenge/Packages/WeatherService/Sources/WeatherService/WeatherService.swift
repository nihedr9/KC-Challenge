// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

public typealias WeatherResponse = Components.Schemas.WeatherResponse

protocol WeatherServiceProtocol {
  func getWeather(
    lat: Double,
    long: Double,
    units: String?,
    lang: String?
  ) async throws -> Components.Schemas.WeatherResponse
}

public struct WeatherService: WeatherServiceProtocol {
    
  let apiKey: String
  
  internal let client: Client
  
  internal static var serverURL: URL {
    if let serverUrl = try? Servers.Server1.url() {
      return serverUrl
    } else {
      return URL(string: "http://api.openweathermap.org/data/2.5")!
    }
  }
  
  public init(apiKey: String) {
    self.apiKey = apiKey
    self.client =  Client(
      serverURL: Self.serverURL,
      transport: URLSessionTransport(),
      middlewares: []
    )
  }
  
  public func getWeather(
    lat: Double,
    long: Double,
    units: String? = "metrics",
    lang: String? = "fr"
  ) async throws -> Components.Schemas.WeatherResponse {
    try await client
      .weather(query: .init(lat: lat, lon: long, units: units, lang: lang, appid: apiKey))
      .ok.body.json
  }
}

extension WeatherResponse {
  public var iconURL: URL? {
    guard let icon = weather.first?.icon,
    let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return nil }
    return url
  }
}

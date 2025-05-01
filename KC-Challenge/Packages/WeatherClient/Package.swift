// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "WeatherClient",
  platforms: [.iOS(.v18)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "WeatherClient",
      targets: ["WeatherClient"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.7.1"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.8.2"),
    .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.2"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "WeatherClient",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
      ]),
    .testTarget(
      name: "WeatherClientTests",
      dependencies: ["WeatherClient"]
    ),
  ]
)

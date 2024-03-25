// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "mrowki",
  dependencies: [
    .package(url: "https://github.com/apple/swift-format.git", branch: ("release/5.8"))
  ],
  targets: [
    .executableTarget(
      name: "mrowki")
  ]
)

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MarkdownUI",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .watchOS(.v10),
    .tvOS(.v16),
    .visionOS(.v1),
    .macCatalyst(.v16),
  ],
  products: [
    .library(
      name: "MarkdownUI",
      targets: ["MarkdownUI"]
    ),
    .library(
      name: "MarkdownUIParser",
      targets: ["MarkdownUIParser"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-markdown", branch: "main"),
    .package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/apple/swift-format", .upToNextMajor(from: "508.0.1")),
  ],
  targets: [
    .target(
      name: "MarkdownUI",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .target(name: "MarkdownUIParser"),
      ]
    ),
    .target(
      name: "MarkdownUIParser",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .testTarget(
      name: "MarkdownUITests",
      dependencies: ["MarkdownUI"]
    ),
  ]
)

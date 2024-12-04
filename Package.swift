// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MarkdownView",
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
      name: "MarkdownView",
      targets: ["MarkdownView"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-markdown", from: "0.5.0"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "MarkdownView",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .testTarget(
      name: "MarkdownViewTests",
      dependencies: [
        .target(name: "MarkdownView"),
      ]
    ),
  ]
)

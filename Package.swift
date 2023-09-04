// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MarkdownUI",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(
      name: "MarkdownUI",
      targets: ["MarkdownUI"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-markdown", branch: "main"),
    .package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    .target(
      name: "MarkdownUI",
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

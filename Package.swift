// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineReSwift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CombineReSwift",
            targets: ["CombineReSwift"]),
    ],
    dependencies: [
         .package(url: "https://github.com/ReSwift/ReSwift", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CombineReSwift",
            dependencies: ["ReSwift"]),
        .testTarget(
            name: "CombineReSwiftTests",
            dependencies: ["CombineReSwift"]),
    ]
)

// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "fixed-size-array-swift",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "generate-fixed-size-array",
            targets: ["FixedSizeArrayGenerator"]),
        .library(
            name: "FixedSizeArray",
            targets: ["FixedSizeArray"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
    ],
    targets: [
        .executableTarget(
            name: "FixedSizeArrayGenerator",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "FixedSizeArray"),
        .testTarget(
            name: "FixedSizeArrayTests",
            dependencies: ["FixedSizeArray"]),
    ]
)

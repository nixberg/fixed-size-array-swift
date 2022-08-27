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
            targets: ["generate-fixed-size-array"]),
        .library(
            name: "FixedSizeArray",
            targets: ["FixedSizeArray"]),
        .plugin(
            name: "FixedSizeArrayGeneratorPlugin",
            targets: ["FixedSizeArrayGeneratorPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
        
        .package(url: "https://github.com/nixberg/subtle-swift", "0.11.0"..<"0.12.0"),
    ],
    targets: [
        .executableTarget(
            name: "generate-fixed-size-array",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/FixedSizeArrayGenerator"),
        .plugin(
            name: "FixedSizeArrayGeneratorPlugin",
            capability: .buildTool(),
            dependencies: ["generate-fixed-size-array"]),
        .target(
            name: "FixedSizeArray"),
        .testTarget(
            name: "FixedSizeArrayTests",
            dependencies: [
                "FixedSizeArray",
                .product(name: "Subtle", package: "subtle-swift"),
            ],
            exclude: ["fixed-size-arrays.json"],
            plugins: ["FixedSizeArrayGeneratorPlugin"]),
    ]
)

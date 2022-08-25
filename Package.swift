// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "fixed-array-swift",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "generate-fixed-array",
            targets: ["FixedArrayGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
    ],
    targets: [
        .executableTarget(
            name: "FixedArrayGenerator",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "FixedArrayTests",
            dependencies: []),
    ]
)

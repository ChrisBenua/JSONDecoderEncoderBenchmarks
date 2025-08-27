// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "codable-benchmark-package",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "RegularModels",
            targets: ["RegularModels"]
        ),
        .library(
            name: "StringCodingKeyModels",
            targets: ["StringCodingKeyModels"]
        ),
        .library(
            name: "StringCodingKeyModelsForSizeMeasurements",
            targets: ["StringCodingKeyModelsForSizeMeasurements"]
        ),
        .library(
            name: "FastCoders",
            targets: ["FastCoders"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "RegularModels"
        ),
        .target(
            name: "FastCoders"
        ),
        .target(
            name: "StringCodingKeyModels"
        ),
        .target(
            name: "StringCodingKeyModelsForSizeMeasurements"
        ),
        .executableTarget(
            name: "codable-benchmark-package",
            dependencies: [
                .target(name: "RegularModels"),
                .target(name: "FastCoders"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .copy("Resources/A1_Hierarchy.json")
            ]
        ),
        .executableTarget(
            name: "codable-benchmark-package-no-coding-keys",
            dependencies: [
                .target(name: "StringCodingKeyModels"),
                .target(name: "FastCoders"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .copy("Resources/A1_Hierarchy.json")
            ]
        ),
        .executableTarget(
            name: "codable-benchmark-package-no-coding-keys-measure-size",
            dependencies: [
                .target(name: "StringCodingKeyModelsForSizeMeasurements"),
                .target(name: "FastCoders"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .copy("Resources/A1_Hierarchy.json")
            ]
        ),
    ]
)

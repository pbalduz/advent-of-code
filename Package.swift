// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms.git",
            .upToNextMajor(from: "1.2.0")
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMajor(from: "1.2.0")
        )
    ],
    targets: [
        .executableTarget(name: "2022"),
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .target(name: "Year2023"),
                .target(name: "Year2024"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            resources: [.copy("Data")]
        ),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"]
        ),
        .target(
            name: "Year2023",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .target(name: "Core")
            ]
        ),
        .target(
            name: "Year2024",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .target(name: "Core")
            ]
        ),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ]
        )
    ]
)

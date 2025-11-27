// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.55.1"),
        .package(url: "https://github.com/gereons/AoCTools", from: "0.1.6"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.3.0")
//        .package(path: "../AoCTools")
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                "AoCTools",
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources",
            // Keep learning notes tracked but out of the build graph to avoid resource warnings.
            exclude: [
                "Day17/Day17-learnings.md",
                "Day18/Day18-learnings.md",
                "Day19/Day19-learnings.md",
                "Day20/Day20-learnings.md",
                "Day21/Day21-Analysis.md",
                "Day21/Day21-learnings.md",
                "Day22/Day22-learnings.md",
                "Day23/Day23-learnings.md"
            ]),
        .testTarget(
            name: "AoCTests",
            dependencies: [
                "AdventOfCode",
                "AoCTools"
            ],
            path: "Tests")
    ]
)

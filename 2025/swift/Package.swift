// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwelveDaysOfCode",
    platforms: [
        .macOS(.v15),
    ],
    dependencies: [
        .package(url: "https://github.com/gereons/AoCTools", from: "0.1.9"),
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "TwelveDaysOfCode",
            dependencies: [
                "AoCTools",
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "Sources",
            exclude: [
                "Day01-learnings.md",
                "Day02-learnings.md",
                "Day03-learnings.md",
                "Day04-learnings.md",
                "Day05-learnings.md",
                "Day06-learnings.md",
                "Day07-learnings.md",
                "Day08-learnings.md",
                "Day09-learnings.md",
                "Day10-learnings.md",
                "Day11-learnings.md",
            ]
        ),
        .testTarget(
            name: "TDOCTests",
            dependencies: ["TwelveDaysOfCode", "AoCTools"],
            path: "Tests"
        ),
    ]
)

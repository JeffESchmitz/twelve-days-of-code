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
    ],
    targets: [
        .executableTarget(
            name: "TwelveDaysOfCode",
            dependencies: [
                "AoCTools",
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "TDOCTests",
            dependencies: ["TwelveDaysOfCode", "AoCTools"],
            path: "Tests"
        ),
    ]
)

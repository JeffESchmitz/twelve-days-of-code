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
    ],
    targets: [
        .executableTarget(
            name: "TwelveDaysOfCode",
            dependencies: ["AoCTools"],
            path: "Sources"
        ),
        .testTarget(
            name: "TDOCTests",
            dependencies: [ "TwelveDaysOfCode", "AoCTools" ],
            path: "Tests")
    ]
)


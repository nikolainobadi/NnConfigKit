// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "NnConfigGenKit",
    products: [
        .library(
            name: "NnConfigGenKit",
            targets: ["NnConfigGenKit"]
        ),
        .executable(
            name: "NnConfigGenKitExecutable",
            targets: ["NnConfigGenKitExecutable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.3.0"),
        .package(url: "https://github.com/kareman/SwiftShell.git", from: "5.1.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "NnConfigGenKit",
            dependencies: [
                "Files",
                "SwiftShell",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "NnConfigGenKitTests",
            dependencies: ["NnConfigGenKit"]
        ),
        .executableTarget(
            name: "NnConfigGenKitExecutable",
            dependencies: ["NnConfigGenKit"]
        )
    ]
)

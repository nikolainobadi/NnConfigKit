// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "NnConfigKit",
    products: [
        .library(
            name: "NnConfigKit",
            targets: ["NnConfigKit"]
        ),
        .executable(
            name: "NnConfigKitExecutable",
            targets: ["NnConfigKitExecutable"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell.git", from: "5.1.0"),
        .package(url: "https://github.com/nikolainobadi/NnTestKit", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "NnConfigKit",
            dependencies: [
                "Files",
                
            ]
        ),
        .executableTarget(
            name: "NnConfigKitExecutable",
            dependencies: [
                "SwiftShell",
                "NnConfigKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "NnConfigKitTests",
            dependencies: [
                "NnConfigKit",
                .product(name: "NnTestHelpers", package: "NnTestKit")
            ]
        )
    ]
)

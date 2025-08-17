// swift-tools-version: 6.0
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
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.3.0"),
        .package(url: "https://github.com/nikolainobadi/NnTestKit", from: "1.3.0"),
        .package(url: "https://github.com/nikolainobadi/NnShellKit.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "NnConfigKit",
            dependencies: [
                "Files"
            ]
        ),
        .executableTarget(
            name: "NnConfigKitExecutable",
            dependencies: [
                "NnShellKit",
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

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NnConfigKit",
    products: [
        .library(
            name: "NnConfigKit",
            targets: ["NnConfigKit"]
        )
    ],
    targets: [
        .target(
            name: "NnConfigKit",
            dependencies: []
        ),
        .testTarget(
            name: "NnConfigKitTests",
            dependencies: [
                "NnConfigKit",
            ]
        )
    ]
)

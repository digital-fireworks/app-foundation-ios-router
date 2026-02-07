// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppFoundationRouter",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AppFoundationRouter",
            targets: ["AppFoundationRouter"]
        )
    ],
    targets: [
        .target(
            name: "AppFoundationRouter"
        ),
        .testTarget(
            name: "AppFoundationRouterTests",
            dependencies: ["AppFoundationRouter"]
        )
    ]
)

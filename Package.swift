// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HPGModerationKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "HPGModerationKit",
            targets: ["HPGModerationKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lovoo/NSFWDetector.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "HPGModerationKit",
            dependencies: [
                .product(name: "NSFWDetector", package: "NSFWDetector")
            ]
        ),
        .testTarget(
            name: "HPGModerationKitTests",
            dependencies: ["HPGModerationKit"]
        ),
    ]
)

// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-random",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Random",
            targets: ["Random"]
        ),
        .library(
            name: "Random Standard Library Integration",
            targets: ["Random Standard Library Integration"]
        ),
        .library(
            name: "Random Apple Foundation Integration",
            targets: ["Random Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Random",
            dependencies: []
        ),
        .target(
            name: "Random Standard Library Integration",
            dependencies: ["Random"]
        ),
        .target(
            name: "Random Apple Foundation Integration",
            dependencies: [
                "Random",
                "Random Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Random Tests",
            dependencies: ["Random"],
            path: "Tests/Random Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}

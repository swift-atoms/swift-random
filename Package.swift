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
            name: "Random Test Support",
            targets: ["Random Test Support"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Random"
        ),
        .target(
            name: "Random Test Support",
            dependencies: [
                "Random"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Random Tests",
            dependencies: [
                "Random",
                "Random Test Support",
            ]
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

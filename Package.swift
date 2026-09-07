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
        .library(name: "Random", targets: ["Random"]),
        .library(name: "Random Standard Library Integration", targets: ["Random Standard Library Integration"]),
        .library(name: "Random Foundation Library Integration", targets: ["Random Foundation Library Integration"]),
        .library(name: "Random Test Support", targets: ["Random Test Support"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Random",
            dependencies: [
            ],
            path: "Sources/Random"
        ),
        .target(
            name: "Random Standard Library Integration",
            dependencies: [
                .target(name: "Random"),
            ],
            path: "Sources/Random Standard Library Integration"
        ),
        .target(
            name: "Random Foundation Library Integration",
            dependencies: [
                .target(name: "Random"),
                .target(name: "Random Standard Library Integration"),
            ],
            path: "Sources/Random Foundation Library Integration"
        ),
        .target(
            name: "Random Test Support",
            dependencies: [
                .target(name: "Random"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Random Tests",
            dependencies: [
                .target(name: "Random"),
                .target(name: "Random Test Support"),
                .target(name: "Random Standard Library Integration"),
                .target(name: "Random Foundation Library Integration"),
            ],
            path: "Tests/Random Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}

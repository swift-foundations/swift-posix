// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-posix",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "POSIX Kernel",
            targets: ["POSIX Kernel"]
        ),

        .library(name: "POSIX Kernel Descriptor", targets: ["POSIX Kernel Descriptor"]),
        .library(name: "POSIX Kernel File", targets: ["POSIX Kernel File"]),
        .library(name: "POSIX Kernel Directory", targets: ["POSIX Kernel Directory"]),
        .library(name: "POSIX Kernel Lock", targets: ["POSIX Kernel Lock"]),
        .library(name: "POSIX Kernel Poll", targets: ["POSIX Kernel Poll"]),
        .library(name: "POSIX Kernel Socket", targets: ["POSIX Kernel Socket"]),
        .library(name: "POSIX Kernel Socket Address", targets: ["POSIX Kernel Socket Address"]),
        .library(name: "POSIX Kernel Memory", targets: ["POSIX Kernel Memory"]),
        .library(name: "POSIX Kernel Signal", targets: ["POSIX Kernel Signal"]),
        .library(name: "POSIX Kernel Process", targets: ["POSIX Kernel Process"]),
        .library(name: "POSIX Kernel Thread", targets: ["POSIX Kernel Thread"]),
        .library(name: "POSIX Kernel Terminal", targets: ["POSIX Kernel Terminal"]),
        .library(name: "POSIX Kernel Environment", targets: ["POSIX Kernel Environment"]),
        .library(name: "POSIX Kernel System", targets: ["POSIX Kernel System"]),
        .library(name: "POSIX Kernel Glob", targets: ["POSIX Kernel Glob"]),
        .library(name: "POSIX Kernel Clock", targets: ["POSIX Kernel Clock"]),
        .library(name: "POSIX Kernel Time", targets: ["POSIX Kernel Time"]),
        .library(name: "POSIX Kernel Identity", targets: ["POSIX Kernel Identity"]),

        .library(
            name: "POSIX Loader",
            targets: ["POSIX Loader"]
        ),

        .library(
            name: "POSIX Test Support",
            targets: ["POSIX Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-error.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-path.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-loader-vocabulary.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-glob.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-either.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-iso/swift-iso-9945.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "POSIX Core",
            dependencies: [
                .product(name: "Error", package: "swift-error"),

                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Descriptor",
            dependencies: [
                "POSIX Core",
                .product(name: "Error", package: "swift-error"),
                .product(name: "Equation", package: "swift-equation"),
                .product(name: "Hash", package: "swift-hash"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel File",
            dependencies: [
                "POSIX Core",
                .product(name: "Path", package: "swift-path"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Directory",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Directory", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Lock",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Lock", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Poll",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Clock",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Poll", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Socket",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Socket", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Kernel Poll", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Socket Address",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Socket Address", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Memory",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Memory", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Signal",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Signal", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Process",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Process", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Thread",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Thread", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Terminal",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Terminal", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Environment",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Environment", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel System",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel System", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Glob",
            dependencies: [
                "POSIX Core",
                .product(name: "Path", package: "swift-path"),
                .product(name: "ISO 9945 Kernel Directory", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),

                .product(name: "ISO 9945 Glob", package: "swift-iso-9945"),
                .product(name: "Glob", package: "swift-glob"),
            ]
        ),

        .target(
            name: "POSIX Kernel Clock",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Clock", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Time",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Time", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel Identity",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Identity", package: "swift-iso-9945"),
            ]
        ),

        .target(
            name: "POSIX Kernel",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                "POSIX Kernel File",
                "POSIX Kernel Directory",
                "POSIX Kernel Lock",
                "POSIX Kernel Poll",
                "POSIX Kernel Socket",
                "POSIX Kernel Socket Address",
                "POSIX Kernel Memory",
                "POSIX Kernel Signal",
                "POSIX Kernel Process",
                "POSIX Kernel Thread",
                "POSIX Kernel Terminal",
                "POSIX Kernel Environment",
                "POSIX Kernel System",
                "POSIX Kernel Glob",
                "POSIX Kernel Clock",
                "POSIX Kernel Time",
                "POSIX Kernel Identity",
            ]
        ),

        .target(
            name: "POSIX Loader",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Loader", package: "swift-iso-9945"),
                .product(name: "Loader", package: "swift-loader-vocabulary"),
            ]
        ),

        .target(
            name: "POSIX Test Support",
            dependencies: [
                "POSIX Kernel",
                "POSIX Loader",
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "POSIX Kernel Tests",
            dependencies: [
                "POSIX Kernel",
                "POSIX Test Support",
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

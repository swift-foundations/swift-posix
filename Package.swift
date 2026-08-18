// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-posix",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
    ],
    products: [
        // MARK: - Kernel (umbrella)
        .library(
            name: "POSIX Kernel",
            targets: ["POSIX Kernel"]
        ),

        // MARK: - Kernel Variants
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

        // MARK: - Loader
        .library(
            name: "POSIX Loader",
            targets: ["POSIX Loader"]
        ),

        // MARK: - Test Support
        .library(
            name: "POSIX Test Support",
            targets: ["POSIX Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-equation-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-hash-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-error-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-path-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-loader-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-glob-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-either-primitives.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-iso/swift-iso-9945.git", branch: "main"),
    ],
    targets: [
        // MARK: - Core (internal — not a published product)

        .target(
            name: "POSIX Core",
            dependencies: [
                .product(name: "Error Primitives", package: "swift-error-primitives"),
                // Wave 3.5-Final-Atomic: POSIX.Kernel.{Permission,Storage} typealiases need iso-9945 Core
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Descriptor (L3-policy per [PLAT-ARCH-005])
        //
        // Hosts POSIX.Kernel.Descriptor — the per-platform descriptor type
        // that the swift-kernel typealias resolves to on POSIX platforms.
        // Authorized by L1-types-only-no-exceptions Research doc (RECOMMENDATION,
        // commit 0666a59 in swift-kernel-primitives) and platform-skill cycle
        // 6cc4fde in swift-institute/Skills (revised PLAT-ARCH-005 / 008c / 015).

        .target(
            name: "POSIX Kernel Descriptor",
            dependencies: [
                "POSIX Core",
                .product(name: "Error Primitives", package: "swift-error-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - File

        .target(
            name: "POSIX Kernel File",
            dependencies: [
                "POSIX Core",
                .product(name: "Path Primitives", package: "swift-path-primitives"),
                .product(name: "Either Primitives", package: "swift-either-primitives"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Directory

        .target(
            name: "POSIX Kernel Directory",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Directory", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Lock

        .target(
            name: "POSIX Kernel Lock",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Lock", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Poll

        .target(
            name: "POSIX Kernel Poll",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Clock",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Poll", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Socket

        .target(
            name: "POSIX Kernel Socket",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Socket", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Kernel Poll", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Socket Address (re-export slot per [PLAT-ARCH-030])

        .target(
            name: "POSIX Kernel Socket Address",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Socket Address", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Memory

        .target(
            name: "POSIX Kernel Memory",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Memory", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Signal

        .target(
            name: "POSIX Kernel Signal",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Signal", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Process

        .target(
            name: "POSIX Kernel Process",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Process", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Thread

        .target(
            name: "POSIX Kernel Thread",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Thread", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Terminal

        .target(
            name: "POSIX Kernel Terminal",
            dependencies: [
                "POSIX Core",
                "POSIX Kernel Descriptor",
                .product(name: "ISO 9945 Kernel Terminal", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Environment

        .target(
            name: "POSIX Kernel Environment",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Environment", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - System

        .target(
            name: "POSIX Kernel System",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel System", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Glob

        .target(
            name: "POSIX Kernel Glob",
            dependencies: [
                "POSIX Core",
                .product(name: "Path Primitives", package: "swift-path-primitives"),
                .product(name: "ISO 9945 Kernel Directory", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
                // ISO 9945 Glob retained for libc Fnmatch wrappers
                // (vocabulary types relocated to L1 swift-glob-primitives per Item 3.5)
                .product(name: "ISO 9945 Glob", package: "swift-iso-9945"),
                .product(name: "Glob Primitives", package: "swift-glob-primitives"),
            ]
        ),

        // MARK: - Clock

        .target(
            name: "POSIX Kernel Clock",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Clock", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Time

        .target(
            name: "POSIX Kernel Time",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Time", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Identity

        .target(
            name: "POSIX Kernel Identity",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Kernel Identity", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Umbrella

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

        // MARK: - Loader

        .target(
            name: "POSIX Loader",
            dependencies: [
                "POSIX Core",
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Loader", package: "swift-iso-9945"),
                .product(name: "Loader Primitives", package: "swift-loader-primitives"),
            ]
        ),

        // MARK: - Test Support

        .target(
            name: "POSIX Test Support",
            dependencies: [
                "POSIX Kernel",
                "POSIX Loader",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests

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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GlowFaceMenuBar",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "GlowFaceMenuBar",
            path: "GlowFaceMenuBar",
            resources: [
                .process("Resources")
            ]
        )
    ]
)

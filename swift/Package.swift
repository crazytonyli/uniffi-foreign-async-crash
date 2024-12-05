// swift-tools-version: 6.0

import Foundation
import PackageDescription

var package = Package(
    name: "NativeLib",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "NativeLib",
            targets: ["NativeLib"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NativeLib",
            dependencies: [.target(name: "RustLib")]
        ),
        .target(
            name: "RustLib",
            dependencies: [
                .target(name: "libForeignAsync")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .binaryTarget(name: "libForeignAsync", path: "../target/swift-bindings/libForeignAsync.xcframework"),
        .testTarget(
            name: "AllTests",
            dependencies: [
                .target(name: "NativeLib"),
                .target(name: "RustLib")
            ]
        )
    ]
)

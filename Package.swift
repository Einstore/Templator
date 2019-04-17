// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Templator",
    products: [
        .library(
            name: "Templator",
            targets: ["Templator"]),
        ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "Templator", dependencies: [
                "Vapor",
                "Leaf",
                "Fluent"
            ]
        ),
        .testTarget(
            name: "TemplatorTests",
            dependencies: ["Templator"]),
        ]
)

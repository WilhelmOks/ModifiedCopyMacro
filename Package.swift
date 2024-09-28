// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ModifiedCopy",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ModifiedCopy",
            targets: ["ModifiedCopy"]
        ),
        .executable(
            name: "ModifiedCopyClient",
            targets: ["ModifiedCopyClient"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "509.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "ModifiedCopyMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "ModifiedCopy", dependencies: ["ModifiedCopyMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "ModifiedCopyClient", dependencies: ["ModifiedCopy"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "ModifiedCopyTests",
            dependencies: [
                "ModifiedCopyMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DGPLibrary",
    platforms: [
       .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DGPLibrary",
            type: .dynamic,
            targets: ["DGPLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "DGPExtensionCore", url: "https://github.com/danielios-hub/dgpextensioncore.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DGPLibrary",
            dependencies: ["DGPExtensionCore"]),
        .testTarget(
            name: "DGPLibraryTests",
            dependencies: ["DGPLibrary"]),
    ]
)

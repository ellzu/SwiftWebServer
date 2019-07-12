// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWebServer",
    products: [
        .executable(
            name: "SwiftWebServer", 
            targets:["SwiftWebServer"]),
        .library(
            name: "SwiftWebServerFoundation", 
            type: .dynamic,
            targets: ["SwiftWebServerFoundation"]),
        .library(
            name: "SwiftWebServerCBridge",
            targets: ["SwiftWebServerCBridge"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftWebServer",
            dependencies: ["SwiftWebServerCBridge","SwiftWebServerFoundation"]),
        .target(
            name: "SwiftWebServerFoundation",
            dependencies: ["PerfectHTTPServer"]),
        .target(
            name: "SwiftWebServerCBridge",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftWebServerTests",
            dependencies: ["SwiftWebServer"]),
    ]
)

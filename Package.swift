// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "Report",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(name: "Report", type: .static, targets: ["Report"]),
        .library(name: "ReportDynamic", type: .dynamic, targets: ["Report"]),
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.4.3")
    ],
    targets: [
        .target(
            name: "Report",
            dependencies: [],
            path: "Sources/Main"
        ),
        .testTarget(
            name: "ReportTests",
            dependencies: ["Report"],
            path: "Sources/Tests"
        )
    ]
)

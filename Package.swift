// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Report",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v12),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "Report", type: .static, targets: ["Report"]),
        .library(name: "ReportDynamic", type: .dynamic, targets: ["Report"]),
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Report",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "ReportTests",
            dependencies: ["Report"],
            path: "sources/tests"
        )
    ]
)

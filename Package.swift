// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Report",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Report", type: .dynamic, targets: ["Report"]),
        .library(name: "ReportStatic", type: .static, targets: ["Report"])
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

// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "AdventOfCode", targets: ["AdventOfCode"]),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            resources: [.copy("Inputs")]
        ),
    ]
)

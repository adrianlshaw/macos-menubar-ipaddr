// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "WiFiStatusBar",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "WiFiStatusBar",
            dependencies: [],
            path: "src/WiFiStatusBar"
        )
    ]
) 
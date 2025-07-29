// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Relay",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Relay",
            targets: ["Relay"]
        )
    ],
    targets: [
        // Your single binary target
        .binaryTarget(
            name: "Relay",
            url: "https://github.com/gandalf-network/relay-macos-sdk-xcframework/releases/download/v.0.1.0-alpha/Relay.xcframework.zip",
            checksum: "9d6d9963ab3516d2900fc1383167b3df84ed7d66c2c8e24633f1ec1b2a4af788"
        )
    ]
)

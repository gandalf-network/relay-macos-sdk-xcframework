// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Relay",                       // the package users will add
    platforms: [
        .macOS(.v12)                     // match whatever you built for
    ],
    products: [
        // This is what client code writes in its “dependencies” list.
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
            checksum: "291f9055e7e88f4382c3c9d6e6aae76cb2bfccc63f12300cf8424c65d2e2eddd"
        )
    ]
)

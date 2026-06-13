// swift-tools-version: 5.8
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "StreetSwedish",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .iOSApplication(
            name: "StreetSwedish",
            targets: ["StreetSwedish"],
            displayVersion: "1.0.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "StreetSwedish",
            path: "StreetSwedish"
        )
    ]
)

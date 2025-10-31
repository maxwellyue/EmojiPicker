// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EmojiPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "EmojiPicker", targets: ["EmojiPicker"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EmojiPicker",
            dependencies: [],
            path: "Sources/EmojiPicker",
            resources: [
                .process("Resources/Localizable.xcstrings")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)

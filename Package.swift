// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "ScreenTransition",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "ScreenTransition", targets: ["ScreenTransition"]),
    ],
    dependencies: [
	.package(url: "https://github.com/mitsuse/box", .upToNextMajor(from: Version(0, 5, 0))),
	.package(url: "https://github.com/mitsuse/screen-container", .upToNextMajor(from: Version(0, 5, 0))),
    ],
    targets: [
        .target(
            name: "ScreenTransition",
            dependencies: [
                .product(name: "Box", package: "box"),
                .product(name: "ScreenContainer", package: "screen-container"),
            ]
        ),
    ]
)

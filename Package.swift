// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SMC",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "SMC",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
            ],
            resources: [
                .process("openapi.yaml"),
                .process("openapi-generator-config.yaml")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        )
    ]
)

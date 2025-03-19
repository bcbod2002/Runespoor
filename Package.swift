// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Runespoor",
    platforms: [.macOS(.v14)],
    products: [.executable(name: "runespoor", targets: ["Runespoor"])],
    dependencies: [.package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.9.0"),
                   .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
                   .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.25.0"),
                   .package(url: "https://github.com/hummingbird-project/hummingbird-auth", from: "2.0.2"),
                   .package(url: "https://github.com/vapor/jwt-kit", from: "5.1.2"),
                   .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.7.0"),],
    targets: [
        .executableTarget(
            name: "Runespoor",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PostgresNIO", package: "postgres-nio"),
                .product(name: "HummingbirdAuth", package: "hummingbird-auth"),
                .product(name: "HummingbirdBasicAuth", package: "hummingbird-auth"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
            ]
        ),
//        .testTarget(name: "RunespoorTests", dependencies: [.target(name: "Runespoor")])
    ],
    swiftLanguageModes: [.v6]
)

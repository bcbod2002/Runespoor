//
//  App.swift
//  Runespoor
//
//  Created by Goston Wu on 19/03/2025.
//

import Foundation
import ArgumentParser
import Hummingbird
import Logging

@main
struct App: AsyncParsableCommand, AppArguments {
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = 8080

    @Option(name: .shortAndLong)
    var logLevel: Logger.Level?

    @Flag
    var inMemoryTesting: Bool = false

    func run() async throws {
        let configuration = ApplicationConfiguration(address: .hostname(hostname, port: port), serverName: "Niffler")
        let app = try await AppBuilder.buildApplication(self)
        try await app.runService()
    }
}

/// Extend `Logger.Level` so it can be used as an argument
#if hasFeature(RetroactiveAttribute)
extension Logger.Level: @retroactive ExpressibleByArgument {}
#else
extension Logger.Level: ExpressibleByArgument {}
#endif

public protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
    var logLevel: Logger.Level? { get }
    var inMemoryTesting: Bool { get }
}

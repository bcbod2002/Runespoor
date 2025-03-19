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
    var hostname: String = ProcessInfo.processInfo.environment["VERCEL"] != nil ? "0.0.0.0" : "127.0.0.1"

    @Option(name: .shortAndLong)
    var port: Int = ProcessInfo.processInfo.environment["PORT"].flatMap(Int.init) ?? 8080

    @Option(name: .shortAndLong)
    var logLevel: Logger.Level?

    @Flag
    var inMemoryTesting: Bool = false

    func run() async throws {
        let app = try await AppBuilder.buildApplication(self)
        
        if ProcessInfo.processInfo.environment["VERCEL"] != nil {
            // Running on Vercel - output JSON response to stdout
            handleVercelResponse()
        } else {
            // Running locally as a normal server
            try await app.runService()
        }
    }
    
    // Handle Vercel serverless environment
    private func handleVercelResponse() {
        // Simple JSON response for Vercel
        let responseJSON = """
        {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": "{\\"message\\":\\"Hello from Runespoor on Vercel\\"}"
        }
        """
        print(responseJSON)
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

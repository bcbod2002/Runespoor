//
//  App+Builder.swift
//  Niffler
//
//  Created by Goston Wu on 19/3/2025.
//

import Hummingbird
import Logging
import PostgresNIO

enum AppBuilder {
    public static func buildApplication(_ arguments: some AppArguments) async throws -> some ApplicationProtocol {
        let environment = Environment()
        let logger = {
            var logger = Logger(label: "Niffler")
            logger.logLevel =
                arguments.logLevel ??
                environment.get("LOG_LEVEL").map { Logger.Level(rawValue: $0) ?? .info } ??
                .info
            return logger
        }()
        

        let router = Router(context: AppRequestContext.self)
        
        var app = Application(
            router: router,
            configuration: .init(
                address: .hostname(arguments.hostname, port: arguments.port),
                serverName: "Runespoor"
            ),
            logger: logger
        )
        
        return app
    }
}

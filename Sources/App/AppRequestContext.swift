//
//  AppRequestContext.swift
//  Runespoor
//
//  Created by Goston Wu on 19/3/2025.
//

import Foundation
import Hummingbird
import HummingbirdAuth

struct AppRequestContext: AuthRequestContext, SessionRequestContext, RequestContext {
    
    var coreContext: CoreRequestContextStorage
    var identity: Never?
    var sessions: SessionContext<UUID> = SessionContext()
    
    init(source: ApplicationRequestContextSource) {
        coreContext = .init(source: source)
    }
}

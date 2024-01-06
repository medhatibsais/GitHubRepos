//
//  NetworkingManager.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation
import Alamofire

/// Networking Manager
class NetworkingManager: Session {
    
    /// Notifications
    enum Notifications: String {
        case connectionLost
        case connectionEstablished
    }
    
    /// Shared
    static let shared: NetworkingManager = NetworkingManager()
    
    /**
     Initializer
     */
    private init() {
        
        super.init(session: Session.default.session, delegate: Session.default.delegate, rootQueue: Session.default.requestQueue)
        
        
    }
}

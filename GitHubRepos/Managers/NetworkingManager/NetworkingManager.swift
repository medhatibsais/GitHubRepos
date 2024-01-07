//
//  NetworkingManager.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation
import Alamofire

/// Networking Manager
class NetworkingManager {
    
    /// Notifications
    enum Notifications: String {
        case connectionLost
        case connectionEstablished
    }
    
    /// Shared
    static let shared: NetworkingManager = NetworkingManager()
    
    /// Network reachability listener
    private let networkReachabilityListener: NetworkReachabilityManager.Listener = { status in
        
        switch status {
            
        case .reachable:
            
            // Post notification
            NotificationCenter.default.post(Notification(name: Notification.Name(NetworkingManager.Notifications.connectionEstablished.rawValue), object: nil, userInfo: nil))
            
        case .notReachable, .unknown:
            
            // Post notification
            NotificationCenter.default.post(Notification(name: Notification.Name(NetworkingManager.Notifications.connectionLost.rawValue), object: nil, userInfo: nil))
        }
    }
    
    /// Network reachability manager
    private let networkReachabilityManager: NetworkReachabilityManager = NetworkReachabilityManager()!
    
    /// Is network reachable
    var isNetworkReachable: Bool {
        return self.networkReachabilityManager.isReachable
    }
    
    /**
     Initializer
     */
    private init() {
        
        // Start listening to network updates
        self.networkReachabilityManager.startListening(onUpdatePerforming: self.networkReachabilityListener)
    }
}

//
//  User.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation

/// User
struct User: Codable {
    
    /// Name
    var name: String
    
    /// imageURL
    var imageURL: String
    
    /**
     Initializer
     */
    init() {
        self.name = ""
        self.imageURL = ""
    }
    
    /**
     Initializer
     - Parameter representation: NSDictionary
     */
    init(representation: NSDictionary) {
        self.init()
        
        /// Set name
        if let value = representation.value(forKey: CodingKeys.name.rawValue) as? String {
            self.name = value
        }
        
        /// Set imageURL
        if let value = representation.value(forKey: CodingKeys.imageURL.rawValue) as? String {
            self.imageURL = value
        }
    }
    
    /// Coding Keys
    private enum CodingKeys: String, CodingKey {
        case name           = "login"
        case imageURL       = "avatar_url"
    }
}

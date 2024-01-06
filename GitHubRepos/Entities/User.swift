//
//  User.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation

struct User: Codable {
    
    var name: String
    
    var imageURL: String
    
    init() {
        self.name = ""
        self.imageURL = ""
    }
    
    init(representation: NSDictionary) {
        self.init()
        
        if let value = representation.value(forKey: CodingKeys.name.rawValue) as? String {
            self.name = value
        }
        
        if let value = representation.value(forKey: CodingKeys.imageURL.rawValue) as? String {
            self.imageURL = value
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case name           = "login"
        case imageURL       = "avatar_url"
    }
}

//
//  Repository.swift
//  GitHubRepos
//
//  Created by Medhat Ibsais on 05/01/2024.
//

import Foundation

/// Repository
struct Repository: Codable {
    
    /// ID
    var id: Int
    
    /// Owner
    var owner: User
    
    /// Name
    var name: String
    
    /// Description
    var description: String
    
    /// Stars rate
    var starsRate: Int
    
    /// Creation date
    var creationDate: Date
    
    /// Forks count
    var forksCount: Int
    
    /// html URL
    var htmlURL: String
    
    /// Language
    var language: String
    
    /// Is favorite
    var isFavorite: Bool
    
    /**
     Initializer
     */
    init() {
        
        // Default values
        self.owner = User()
        self.name = ""
        self.description = NSLocalizedString("repository.description.default", comment: "")
        self.starsRate = 0
        self.id = 0
        self.creationDate = Date()
        self.forksCount = 0
        self.htmlURL = ""
        self.language = ""
        self.isFavorite = false
    }
    
    /**
     Initializer
     - Parameter representation: NSDictionary
     */
    init(representation: NSDictionary) {
        self.init()
        
        // Set id
        if let value = representation.value(forKey: CodingKeys.id.rawValue) as? Int {
            self.id = value
        }
        
        // Set owner
        if let value = representation.value(forKey: CodingKeys.owner.rawValue) as? NSDictionary {
            self.owner = User(representation: value)
        }

        // Set name
        if let value = representation.value(forKey: CodingKeys.name.rawValue) as? String {
            self.name = value
        }

        // Set description
        if let value = representation.value(forKey: CodingKeys.description.rawValue) as? String {
            self.description = value
        }
        
        // Set starsRate
        if let value = representation.value(forKey: CodingKeys.starsRate.rawValue) as? Int {
            self.starsRate = value
        }
        
        // Set forksCount
        if let value = representation.value(forKey: CodingKeys.forksCount.rawValue) as? Int {
            self.forksCount = value
        }
        
        // Set language
        if let value = representation.value(forKey: CodingKeys.language.rawValue) as? String {
            self.language = value
        }
        
        // Set htmlURL
        if let value = representation.value(forKey: CodingKeys.htmlURL.rawValue) as? String {
            self.htmlURL = value
        }
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US")
        
        // Set creationDate
        if let value = representation.value(forKey: CodingKeys.creationDate.rawValue) as? String, let date = dateFormatter.date(from: value) {
            self.creationDate = date
        }
        
        // Set isFavorite
        self.isFavorite = FavoriteRepositoriesCachingManager.shared.getRepositories().contains(where: { $0.id == self.id })
    }
    
    /// Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case isFavorite
        case creationDate   = "created_at"
        case forksCount     = "forks"
        case htmlURL        = "html_url"
        case owner          = "owner"
        case starsRate      = "stargazers_count"
    }
    
    /// Order
    enum Order: String {
        case descending     = "desc"
        case ascending      = "asc"
    }
    
    /// Sort
    enum Sort: String {
        case stars
    }
}
